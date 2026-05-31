@echo off
echo ============================================
echo  LIMPEZA DE SAIDAS - Lista 2 Altimetria
echo ============================================
echo.
echo Esta operacao ira apagar TODO o conteudo de:
echo   - plots\
echo   - processed-data\
echo.
set /p CONFIRM="Deseja continuar? (S/N): "
if /i not "%CONFIRM%"=="S" (
    echo Operacao cancelada.
    exit /b 0
)
echo.

echo [1/2] Limpando plots\...
if exist plots (
    for /d %%D in (plots\*) do rd /s /q "%%D"
    del /q plots\* 2>nul
    echo      Subpastas e arquivos removidos.
) else (
    echo      Pasta plots\ nao encontrada.
)

echo [2/2] Limpando processed-data\...
if exist processed-data (
    for /d %%D in (processed-data\*) do rd /s /q "%%D"
    del /q processed-data\* 2>nul
    echo      Subpastas e arquivos removidos.
) else (
    echo      Pasta processed-data\ nao encontrada.
)

echo.
echo Limpeza concluida. As pastas foram esvaziadas mas mantidas.
echo Execute altim_L2_adriano_caversan.m para regenerar os dados.
echo.
pause
