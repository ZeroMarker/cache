function LoadFile()
	{	ErrorTextObj.value=""
		window.status="程序进行中"
		var ss="<table id="+"TableDataTitle"+" width=2000 border=1>"+"</table>"
		ss=ss+"<div style="+"overflow:auto;height=450"+">"
		ss=ss+"<table id="+"TableData"+" border=1>"+"</table></div>"
		document.all.aaa.innerHTML=ss
		var OpenFileObj=document.all.OpenFile;
		
		if (!OpenFileObj || OpenFileObj.value=="") {alert("没有要装入的文件");OpenFileObj.focus();window.status="完毕";return}
		CircleNums=2
		for (Circle=1;Circle<CircleNums+1;Circle++)
				{ 
					var TemData=ReadFromExcel(OpenFileObj.value,Circle);
					if (Circle==1) 
					{  
						TableFill("TableDataTitle",TemData,1,1,Circle);
						TableFill("TableData",TemData,2,"",Circle)
					}
					else 
					{ TableFill("TableData",TemData,1,"",Circle)
					}
				}
		window.status="完毕"
	}
function GetFile()
	{ 
		for (var aa=15;aa<16;aa++)
			{ErrorTextObj.value=""
				window.status="程序进行中"
				var FileName=""
				if (aa==1) {FileName="e:\\tmp\\file01.xls"}
				if (aa==2) {FileName="e:\\tmp\\file02.xls"}
				if (aa==3) {FileName="e:\\tmp\\file03.xls"}
				if (aa==4) {FileName="e:\\tmp\\file04.xls"}
				if (aa==5) {FileName="e:\\tmp\\file05.xls"}
				if (aa==6) {FileName="e:\\tmp\\file06.xls"}
				if (aa==7) {FileName="e:\\tmp\\file07.xls"}
				if (aa==8) {FileName="e:\\tmp\\file08.xls"}
				if (aa==9) {FileName="e:\\tmp\\file09.xls"}
				if (aa==10) {FileName="e:\\tmp\\file10.xls"}
				if (aa==11) {FileName="e:\\tmp\\file11.xls"}
				if (aa==12) {FileName="e:\\tmp\\file12.xls"}
				if (aa==13) {FileName="e:\\tmp\\file13.xls"}
				if (aa==14) {FileName="e:\\tmp\\file14.xls"}
				if (aa==15) {FileName="e:\\tmp\\file15.xls"}
				if (aa==16) {FileName="e:\\tmp\\file16.xls"}
				//FileName="e:\\tmp\\fhq.xls"
				for (var Circle=1;Circle<CircleNums;Circle++)
				{
					var TemData=ReadFromExcel(FileName,Circle);
					var RowNum=TemData.length;
					alert
					for (var i=1;i<RowNum+1;i++)
					{  if (TemData[i-1]!="")
						{
							SetGloble(TemData[i-1]);
					   		window.status="填充数据:"+((Circle-1)*FetchRows+i)+"行";
						}
					}
				}
			}
			window.status="完毕"
	
	}