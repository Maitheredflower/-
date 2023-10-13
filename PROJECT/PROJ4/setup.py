from distutils.core import setup, Extension
import sysconfig

def main():
    CFLAGS = ['-g', '-Wall', '-std=c99', '-fopenmp', '-mavx', '-mfma', '-pthread', '-O3']
    LDFLAGS = ['-fopenmp']
    # Use the setup function we imported and set up the modules.
    # You may find this reference helpful: https://docs.python.org/3.6/extending/building.html
    module = Extension('numc',
                       include_dirs=['/home/ytq/codeField/CS61C/PROJECT/PROJ4'],
                       sources=['numc.c']
                       )
    
    setup(
        name='My numc',
        version='1.0',
        description='This is my numc Cython library',
        ext_modules=[module]
    )

if __name__ == "__main__":
    main()
