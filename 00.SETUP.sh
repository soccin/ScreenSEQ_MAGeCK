module load gcc/11.2.0
mkdir src
wget https://sourceforge.net/projects/mageck/files/0.5/mageck-0.5.9.5.tar.gz/download -O src/mageck-0.5.9.5.tar.gz
tar xvfz src/mageck-0.5.9.5.tar.gz

/juno/work/bic/socci/opt/common/CentOS_7/python/python-3.11.3/bin/python3 -m venv ve.mageck
. ve.mageck/bin/activate
pip install --upgrade pip
pip install numpy
pip install scipy
cd liulab-mageck-c491c3874dca/
python setup.py install
cd ..
