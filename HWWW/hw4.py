# Nutsa Margvelashvili


from ftplib import FTP, error_perm
import os

class FTP_Client(FTP):
    def __init__(self, host='127.0.0.1', user='user1', passw='test123'):
        super().__init__(host, user, passw)

    def __str__(self):
        return self.getwelcome()

    def ftp_UploadFile(self, file1, file2, size=4096):
        """ Uploads file file1 to FTP server with name file2. """
        if os.path.isfile(file1):
            with open(file1, 'rb') as file:
                self.storbinary('STOR ' + file2, file, size)
        elif os.path.isdir(file1):
            self.mkd(file2)
            for filename in os.listdir(file1):
                self.ftp_UploadFile(os.path.join(file1, filename), os.path.join(file2, filename), size)
        else:
            print('File or directory not found!')

    def ftp_DownloadFile(self, file1, file2):
        """ Downloads file file1 from FTP server with name file2. """
        with open(file2, 'wb') as file:
            self.retrbinary('RETR ' + file1, file.write)

    def ftp_RenameFile(self, fromName, toName):
        """ Rename file fromName on the server to toName """
        self.rename(fromName, toName)

    def ftp_DeleteFile(self, FileName):
        """ Remove the file named FileName from the server """
        try:
            self.delete(FileName)
        except error_perm:
            print("Such file does not exist!!!")

    def ftp_CreateDirectory(self, DName):
        """ Create a new directory on the server """
        self.mkd(DName)

    def ftp_DeleteFolder(self, DName):
        """ Remove the directory named DName on the server """
        try:
            self.rmd(DName)
        except error_perm:
            print("Such folder does not exist!!!")

def main():
    # create an instance of FTP_Client class
    ftp = FTP_Client()

    # test ftp_UploadFile method
    ftp.ftp_UploadFile('test.txt', 'test_ftp.txt')
    ftp.ftp_UploadFile('test_folder', 'test_folder_ftp')

    # test ftp_DownloadFile method
    ftp.ftp_DownloadFile('test_ftp.txt', 'test_download.txt')

    # test ftp_RenameFile method
    ftp.ftp_RenameFile('test_ftp.txt', 'test_ftp_renamed.txt')

    # test ftp_DeleteFile method
    ftp.ftp_DeleteFile('test_ftp_renamed.txt')

    # test ftp_CreateDirectory method
    ftp.ftp_CreateDirectory('test_folder_ftp_new')

    # test ftp_DeleteFolder method
    ftp.ftp_DeleteFolder('test_folder_ftp')

    # close the FTP connection
    ftp.quit()

if __name__ == '__main__':
    main()

