
Dim DicFolders As Variant

Private Sub ExportFormat(format As String)

    Dim ArrFileName() As String, ArrLan() As String, i&

    Dim sheetName As String, sheetActive As Variant, m&, lIndex As Long, inteval&

    On Error Resume Next

    sheetName = format + "Language.xls"

    Workbooks.Add

    ActiveWorkbook.SaveAs ThisWorkbook.Path & "\" + sheetName, True

    ArrFileName = ExtractFileName(ThisWorkbook.Path, ".pas")

    Windows(sheetName).Activate

    Set sheetActive = ActiveSheet

    sheetActive.Cells(1, 1) = "FileName"

    sheetActive.Cells(1, 2) = "FilePath"

    sheetActive.Cells(1, 3) = "Information"

    lIndex = 2

    inteval = 2

    For i = LBound(ArrFileName) To UBound(ArrFileName)

        If (ArrFileName(i) <> "") Then

            strText = ReadText(ArrFileName(i), format)

            ArrLan = FindString(strText, "frmLan.GetLanStr\((.*\s.*\s.*\s.*)\)")

         ' save result to excel

         For m = LBound(ArrLan) To UBound(ArrLan)

            If m = 0 Then

                sheetActive.Cells(lIndex, 1) = Right(ArrFileName(i), Len(ArrFileName(i)) - InStrRev(ArrFileName(i), "\"))

                sheetActive.Cells(lIndex, 2) = ArrFileName(i)

            End If

            sheetActive.Cells(m + lIndex, 3) = ArrLan(m)

         Next m

         lIndex = lIndex + m + inteval

        End If

    Next i

End Sub

Private Sub btnExport_Click()

   ExportFormat ("UTF-8")

End Sub

Sub btnExportGB_Click()

   ExportFormat ("GB2312")

End Sub

'FilePath:Current File Path

'FileFilter:suffix such as .pas,.txt

' return : array of string

Function ExtractFileName(ByVal FilePath As String, Optional ByVal FileFilter As String = "*.*") As String()

Dim i&, n&, Mypath$, Arr() As String, strIndex As String

On Error Resume Next

    Set DicFolders = CreateObject("Scripting.Dictionary")

    DicFolders.Add (FilePath & "\"), ""

    i = 0

    Do While i < DicFolders.Count

        ke = DicFolders.keys

        Filename = Dir(ke(i), vbDirectory)

            Do While Filename <> ""

                If Filename <> "." And Filename <> ".." Then

                    If (GetAttr(ke(i) & Filename) And vbDirectory) = vbDirectory Then

                        DicFolders.Add (ke(i) & Filename & "\"), ""

                    End If

                End If

                Filename = Dir

            Loop

        i = i + 1

    Loop

  i = 0

'**********************************************************************************

        For Each ke In DicFolders.keys

            MyFliename = Dir(ke)

            Do While MyFliename <> ""

               strIndex = Right(MyFliename, 4)

               If strIndex = FileFilter Then

                    ReDim Preserve Arr(i)

                    Arr(i) = ke & MyFliename

                    i = i + 1

               End If

                MyFliename = Dir

            Loop

        Next

    ExtractFileName = Arr

 

End Function

' Description:read the txt file and return as as string

' FilePath:the absolute path of the file

' strFormat:the text format such as UTF-8,GB2312

' Return an String

Function ReadText(FilePath As String, strFormat As String) As String

    'Dim fso As Variant, f As Variant

    'Set fso = CreateObject("Scripting.FileSystemObject")

    'Set f = fso.OpenTextFile(FilePath)

    'ReadText = f.ReadAll

    Dim st As Variant

    Set st = CreateObject("ADODB.Stream")

    st.Type = 2

    st.Mode = 3

    st.Open

    st.LoadFromFile FilePath

    st.Charset = strFormat

    ReadText = st.ReadText

    st.Close

End Function

'Description:Find the strings that match with the Regular Format

'strText:string to be find

'RegFormat:Regular expressions

'return as an array of string

Function FindString(strText As String, Optional ByVal RegFormat As String = "*.*") As String()

    Dim Reg As Variant, m As Variant, Arr() As String, n&

    Set Reg = CreateObject("vbScript.RegExp")

    If strText <> "" Then

        Reg.Pattern = RegFormat

        Reg.Global = True

        Reg.IgnoreCase = True

        Reg.MultiLine = False

        ReDim Preserve Arr(1)

        For Each m In Reg.Execute(strText)

            n = n + 1

            ReDim Preserve Arr(n)

            Arr(n) = m

        Next

    End If

    FindString = Arr

End Function
