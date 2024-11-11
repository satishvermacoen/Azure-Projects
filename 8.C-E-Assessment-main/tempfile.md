## Task 3.

### Advanced Application Deployment

1. Fork the example repository [here](https://github.com/render-examples/flask-hello-world/tree/master).

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)

2. Deploy the code on the VM.
- Install Required Dependencies
Flask is a python-based application. So Python and other required dependencies must be installed on your server. If not installed you can install all of them with the following command:

```bash
apt-get install python3 python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools -y


```
Error message:
```
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try apt install
    python3-xyz, where xyz is the package you are trying to
    install.

    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.

    If you wish to install a non-Debian packaged Python application,
    it may be easiest to use pipx install xyz, which will manage a
    virtual environment for you. Make sure you have pipx installed.

    See /usr/share/doc/python3.12/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.

```
Solution:-
```bash
apt install pipx

pipx install some-python-application
```
Once all the dependencies are installed, install the Python virtual environment package using the following command:

```bash
apt-get install python3-venv -y
```

3. Create a system service to automatically start the application whenever the VM restarts.
4. Configure NGINX as a reverse proxy for the Flask application.

