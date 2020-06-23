Option Explicit
Sub search()
'完成对表格单元格中关键字的匹配查找
'Debug.Print "~~~~~~~~~~~~~~~~~~~~~~~~"
'变量声明
Dim column_num, row_num, File_sum, Sum_Workbook, search_file, _
        temp_Workbook, sheet_num, key_word, record_num, File_Dir, i
   ' column_num, 列数标识； row_num，行数标识
   ' File_sum，汇总文件
   ' Sum_Workbook， 汇总工作薄
   ' search_file, 待处理的文件
   ' temp_Workbook, 处理中的工作薄
   ' sheet_num, 处理中工作薄的表格数
   'key_word, 查询的关键字
   'record_num，匹配记录数目
   ' File_Dir, 路径
   'i, 循环控制
   '-----------------------------------------------------------------
   
'打开文件
    '打开汇总表格     '^^^^^^
 File_sum = "E:\code\关键字.xls"  '后期施工：如何自行创建excel文件，如creatobject()
 Set Sum_Workbook = GetObject(File_sum)

    '计算待处理的文件数

'搜寻待工作薄所在路径下的给定xls文件
File_Dir = ThisWorkbook.Path
'search_file = ""
'search_file = Dir(File_Dir & "\*第*天*.xls*")   '^^^^^^
'            计算文件个数
'            i = 0
'            Do While Len(search_file) > 0
'                Debug.Print search_file
'                search_file = Dir()
'                i = i + 1
'            Loop
'            Debug.Print "共有" & i; "个登记表！"
'            i = i + Start_row '确定记录添加行数
' ----------------------------------------------------------------
'单元格匹配查找
key_word = "*区*"      '^^^^^^
record_num = 1
search_file = ""
search_file = Dir(File_Dir & "\*第*天*.xls*")      '^^^^^^

Sum_Workbook.Worksheets(1).UsedRange.Clear

Do While search_file <> ""   '若不为空，遍历开始
        If search_file Like "*第*天*" Then       '^^^^^^
            '打开工作薄、表格-------
            Set temp_Workbook = GetObject(File_Dir & "\" & search_file)
            'Debug.Print "------" & search_file & "匹配查找开始："
            '**************************************
                sheet_num = temp_Workbook.Worksheets.Count
                For i = 1 To sheet_num   '工作表遍历
                    '剔除空白表格
'                    Debug.Print temp_Workbook.Worksheets(i).UsedRange.Rows.Count
'                    Debug.Print temp_Workbook.Worksheets(i).UsedRange.Columns.Count
                    
                    If (temp_Workbook.Worksheets(i).UsedRange.Rows.Count > 1) _
                       And (temp_Workbook.Worksheets(i).UsedRange.Columns.Count _
                            > 1) Then
                        '行数循环
                        For row_num = 1 _
                            To temp_Workbook.Worksheets(i).UsedRange.Rows.Count
                            '列数循环
                            For column_num = 1 _
                                To temp_Workbook.Worksheets(i).UsedRange.Columns.Count
                                '-------------*******------------------
                                If temp_Workbook.Worksheets(i).UsedRange.Cells(row_num, _
                                    column_num) Like key_word Then
                                    Sum_Workbook.Worksheets(1).Cells(record_num, 1) = _
                                        temp_Workbook.Worksheets(i).UsedRange.Cells(row_num, _
                                        column_num)
                                    Debug.Print "符合条件的记录已经找到： " & _
                                        temp_Workbook.Worksheets(i).UsedRange.Cells(row_num, _
                                        column_num)
                                    record_num = record_num + 1
                                End If
                                '-------------*******------------------
                            Next '----列数循环结束
                        Next '----行数循环结束
                    End If '----排除空白表格结束
                Next '----工作表循环结束
                
        End If   '------工作薄匹配结束
        search_file = Dir() '-------匹配下一个工作薄
        
    Loop   '------工作薄循环结束
    record_num = record_num - 1
    Debug.Print "匹配完成，共有 " & record_num; "条记录符合关键字查找条件！"
End Sub
