# Miro board link for the complete architecutre
**https://miro.com/app/board/uXjVJr_Eg1Q=/?share_link_id=788097251001**

# Building a chat bot and containerising the application and push the image to dockerhub

# How to Create a Virtual Environment on Linux

## Steps

1. **Open Terminal**

2. **Navigate to your project directory** (or where you want the virtual environment to be created):
   ```bash
   cd /path/to/your/project
   ```   
3. **Create the virtual environment:**
   ```bash
   python3.12 -m venv pythonclass-py-3.12
   python3 -m venv pythonclass-py-3.12
   ``` 
4. **Activate the virtual environment:**
   ```bash
   source pythonclass-py-3.12/bin/activate
   ```    
5. **Verify Python version inside the virtual environment:**   
    ```bash
    python --version
    ```
6. **Install any necessary packages:**
   ```bash
   pip install -r requirements.txt
   ```
7. **Deactivate the virtual environment:**
    ```bash
    deactivate
    ```
==================
**Install AWS CLi**
 1. **snap install aws-cli --classic**

**Add docker permissions**
 1. **usermod -aG docker jenkins**
    **usermod -aG docker ubuntu**
    **checks the modifications below location**
    **cat /etc/group/**
 2. **systemctl restart jenkins**
 **If not added you may get permission error in the docker build stage**

**Give docker hub permissions to the jenkins so add the credentials in jenkins credetianls tab**

 **FLOW CHART**

![alt text](Images/image-1.png)



![alt text](Images/image-2.png)

**Pipeline**

![alt text](Images/image.png)