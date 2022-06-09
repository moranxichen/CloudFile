import Account
import smtplib
from email.mime.text import MIMEText

def mail(content):
    title = '微元素摇奖信息'  # 邮件主题
    message = MIMEText(content, 'plain', 'utf-8')  # 内容, 格式, 编码
    message['From'] = "{}".format(Account.sender)
    message['To'] = ",".join(Account.receivers)
    message['Subject'] = title
    try:
        smtpObj = smtplib.SMTP_SSL(Account.mail_host, 465)  # 启用SSL发信, 端口一般是465
        smtpObj.login(Account.mail_user, Account.mail_pass)  # 登录验证
        smtpObj.sendmail(Account.sender, Account.receivers, message.as_string())  # 发送
        print("邮件成功发送.")
    except smtplib.SMTPException as e:
        print(e)

def main(text):
    mail("\n\n\n\n\n\n"+"Python自动化完成!"+"\n\n\n\n\n\n"+text+"\n\n\n\n\n\n")
