#include <stdio.h>
#include <windows.h>


#define MAX_PATH_LEN 260

void ScanDiretory(const char* dir, FILE *file)
{
    WIN32_FIND_DATAA ffd;  
    HANDLE hFind = INVALID_HANDLE_VALUE;
    char szDirWithPattern[MAX_PATH_LEN];

    snprintf(szDirWithPattern, MAX_PATH_LEN, "%s\\*", dir);

    hFind = FindFirstFileA(szDirWithPattern, &ffd );
    if(hFind == INVALID_HANDLE_VALUE)
    {
        fprintf(file, "Error: \n", dir);
        return;
    }

    do
    {
        if(strcmp(ffd.cFileName, ".") == 0 || strcmp(ffd.cFileName, "..") == 0)
        {
            continue;
        }

        char fullPath[MAX_PATH_LEN];
        snprintf(fullPath, MAX_PATH_LEN, "%s\\%s", dir, ffd.cFileName);

        

        fprintf(file, "%s\n", fullPath, strlen(fullPath));

        if(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
        {
            ScanDiretory(fullPath, file);

        }

    } while (FindNextFileA(hFind, &ffd) != 0);

    FindClose(hFind);
    

}


int main(void)
{
    const char* dir = "C:";

    FILE *file; 
    file = fopen("scan.txt", "w");
    if(file == NULL){
        perror("File Error");
        return 1;
    }
    ScanDiretory(dir, file);
    fclose(file);
    return EXIT_SUCCESS;


}