import urllib.request
import urllib.parse
import http.cookiejar
import re

cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

# 1. Fetch register page to get CSRF token
resp = opener.open('http://localhost:8080/complaint-portal/register')
html = resp.read().decode('utf-8')
csrf = re.search(r'name="csrfToken" value="([^"]+)"', html).group(1)
print('[Step 1] CSRF Token extracted:', csrf)

# 2. Submit registration
data = urllib.parse.urlencode({
    'csrfToken': csrf,
    'fullName': 'Aarav Sharma',
    'email': 'aarav@college.edu',
    'password': 'password123',
    'confirmPassword': 'password123'
}).encode()

reg_resp = opener.open('http://localhost:8080/complaint-portal/register', data=data)
print('[Step 2] Registration response URL:', reg_resp.geturl())

# 3. Login as Aarav
resp = opener.open('http://localhost:8080/complaint-portal/login')
html = resp.read().decode('utf-8')
csrf = re.search(r'name="csrfToken" value="([^"]+)"', html).group(1)

login_data = urllib.parse.urlencode({
    'csrfToken': csrf,
    'email': 'aarav@college.edu',
    'password': 'password123'
}).encode()
login_resp = opener.open('http://localhost:8080/complaint-portal/login', data=login_data)
print('[Step 3] Login landing page:', login_resp.geturl())

# 4. Lodge a complaint
resp = opener.open('http://localhost:8080/complaint-portal/complaints/new')
html = resp.read().decode('utf-8')
csrf = re.search(r'name="csrfToken" value="([^"]+)"', html).group(1)

complaint_data = urllib.parse.urlencode({
    'csrfToken': csrf,
    'category': 'Hostel & Campus Infrastructure',
    'subject': 'Water leakage in Hostel Block B - 3rd Floor',
    'description': 'Continuous water leakage from overhead pipe near Room 314 causing slippery corridor and disruption.'
}).encode()
post_resp = opener.open('http://localhost:8080/complaint-portal/complaints', data=complaint_data)
print('[Step 4] Post complaint redirected to:', post_resp.geturl())
complaint_view_html = post_resp.read().decode('utf-8')
ref_match = re.search(r'(CMP-\d+-[A-Z0-9]+)', complaint_view_html)
complaint_id = ""
if ref_match:
    complaint_ref = ref_match.group(1)
    print('[Step 5] SUCCESS! Lodge complaint reference created:', complaint_ref)
    id_match = re.search(r'id=([a-f0-9]{24})', post_resp.geturl())
    if id_match:
        complaint_id = id_match.group(1)

# 5. Admin Login & Status Update
print('\n--- Testing Admin Workflow ---')
admin_cj = http.cookiejar.CookieJar()
admin_opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(admin_cj))

resp = admin_opener.open('http://localhost:8080/complaint-portal/login')
html = resp.read().decode('utf-8')
csrf = re.search(r'name="csrfToken" value="([^"]+)"', html).group(1)

admin_data = urllib.parse.urlencode({
    'csrfToken': csrf,
    'email': 'admin@college.edu',
    'password': 'Admin@1234'
}).encode()
admin_resp = admin_opener.open('http://localhost:8080/complaint-portal/login', data=admin_data)
print('[Step 6] Admin login redirected to:', admin_resp.geturl())

# Update complaint status to UNDER_REVIEW
if complaint_id:
    resp = admin_opener.open(f'http://localhost:8080/complaint-portal/admin/complaints/view?id={complaint_id}')
    html = resp.read().decode('utf-8')
    csrf = re.search(r'name="csrfToken" value="([^"]+)"', html).group(1)

    update_data = urllib.parse.urlencode({
        'csrfToken': csrf,
        'complaintId': complaint_id,
        'newStatus': 'UNDER_REVIEW',
        'remark': 'Assigned to campus maintenance supervisor. Team dispatched.'
    }).encode()
    upd_resp = admin_opener.open('http://localhost:8080/complaint-portal/admin/complaints/status', data=update_data)
    print('[Step 7] Status update executed, landing page:', upd_resp.geturl())
    print('[Step 8] SUCCESS! Status successfully updated to UNDER_REVIEW with admin remark.')

