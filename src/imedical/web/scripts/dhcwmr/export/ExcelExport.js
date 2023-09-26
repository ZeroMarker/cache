function GridExportExcel(objGrid,needSave)
{
	var objStore = objGrid.getStore();
	objStore.load({
		
		callback : function(r, o){
			var objParam = o.params;
			objParam.start = "";
			objParam.limit = "";
			
			var objResult = ExtTool.RunQuery(objParam, 
				function(arryResult, extraArg){
					//window.alert(arryResult.length);
					
					var objFSO = new ActiveXObject("Scripting.FileSystemObject");
					var objTmpFolder = objFSO.GetSpecialFolder(2);
					var tmpFileName = objTmpFolder.Path + "\\" + objFSO.GetTempName();
					var objFile = objFSO.CreateTextFile(tmpFileName, true);
					
					
					
					
					var objColModel = objGrid.getColumnModel();
					var strHTML = "<HTML><BODY>\r\n";
					strHTML += "<STYLE>\r\n";
					strHTML += "td {padding:0 0 0 0;margin:0 0 0 0;height:23px;border:none;border-color:Gray;}\r\n";
					strHTML += "th {padding:9px;line-height:18px;text-align:left;vertical-align:top;border:none;background-color:rgb(238,238,238)}\r\n";
					strHTML += "</STYLE>\r\n";
					
					
					strHTML += "<TABLE>";
					strHTML += "<TR>";
					for(var i = 0; i < objColModel.getColumnCount(); i ++){
						if(objColModel.getColumnHeader(i)  == "")
							continue;
						strHTML += "<TH>" + objColModel.getColumnHeader(i) + "</TH>"
					}
					strHTML += "</TR>\r\n"
					objFile.WriteLine(strHTML);
					strHTML = "";
					
					//debugger;
					for(var i = 0; i < arryResult.length; i ++)
					{
						var objRow = arryResult[i];
						
						strHTML = "<TR>"
						
						for(var col = 0; col < objColModel.getColumnCount(); col ++) {
							if(objColModel.getColumnHeader(col)  == "")
								continue;						
							//if(objRow[objColModel.getDataIndex(col)] == null)
							//	continue;
							strHTML += "<TD>";
							if((objRow[objColModel.getDataIndex(col)] != "")||(objRow[objColModel.getDataIndex(col)] != null))
								strHTML += objRow[objColModel.getDataIndex(col)];
							else
								strHTML += "&nbsp;"
							strHTML += "</TD>";
						}
						
						strHTML += "</TR>\r\n"
						objFile.WriteLine(strHTML);
					}
					
					
					objFile.WriteLine("</TABLE>\r\n");
					objFile.WriteLine("</BODY>\r\n");
					objFile.Close();
					
					
					var objExcel = new ActiveXObject("Excel.Application");
					objExcel.Visible = true;
					var objBook = objExcel.Workbooks.Add(tmpFileName);
					if (needSave)
						objExcel.Application.Dialogs.Item(5).Show("report.xls", 1);
				}
			);
			
			
		
		}
	});




}