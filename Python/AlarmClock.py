import tkinter as tk
import tkinter.messagebox
import time

def Rupdate():
    now_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    TimeLabel.config(text=now_time)
    AC_Window.after(1000,Rupdate)

AC_Window = tk.Tk()
AC_Window.title ("AlarmClock")
AC_Window.geometry("200x100")
AC_Window.minsize(100,100)
AC_Window.wm_attributes('-topmost',1)
AC_Window.config(bg = "black")

TimeLabel = tk.Label(AC_Window,text = "Time",font = ("微软雅黑",10),fg = "white" ,bg = "black")
TimeLabel.pack()

Rupdate()
AC_Window = tk.mainloop()

#test