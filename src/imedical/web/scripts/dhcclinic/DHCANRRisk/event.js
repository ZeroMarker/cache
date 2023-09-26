
function InitViewScreenEvent(obj)
{
	var _DHCANRRisk=ExtTool.StaticServerObject('web.DHCANRRisk');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');	
	var intReg=/^[1-9]\d*$/;
	var AppDateCheck="N",OutDateCheck="N"
	obj.LoadEvent = function(args)
	{		
		//obj.tb.doLayout();	
		var loc="^".split("^");
		var ret=_DHCANRRisk.GetLocDesc(session['LOGON.CTLOCID'])
	    if (ret!="")
	    {
			loc=ret.split("^");
	    } 
		obj.comAppLoc.setValue(loc[1]);
		obj.comAppLoc.setRawValue(loc[0]);
				
		var item = new Ext.menu.Item({
						text : '风险评估导出',
						id : 'anrRiskOut',
						handler:OnMenuClick
					});
		obj.opManageMenu.addItem(item);
		
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANRRisk';
			param.QueryName = 'GetANRRisk';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comRiskStat.getValue();
			param.Arg4 = obj.comRiskSort.getValue();
			param.Arg5 = obj.comAppLoc.getValue();
			param.Arg6 = obj.OperDiffculty.getValue();
			param.Arg7 = obj.ASA.getValue();
			param.Arg8 = obj.Anrcrc.getValue();
			param.Arg9 = obj.txtMedCareNo.getValue();
			param.Arg10 = obj.ManageClass.getValue();
			param.Arg11 = "";
			param.Arg12 = "";
			param.Arg13 = AppDateCheck+"^"+OutDateCheck;								
			param.ArgCnt = 13;
		});		
		obj.retGridPanelStore.load({
			
			params : {
				start:0
				,limit:200
			}
		});  
	}
	obj.btnSch_click = function()
	{	
		if(obj.chkapply)
		{
			AppDateCheck=obj.chkapply.getValue()?"Y":"N";
		}
		if(obj.chkoutDept)
		{
			OutDateCheck=obj.chkoutDept.getValue()?"Y":"N";
		}
		//obj.InDateType.setValue(obj.chkapply.getValue()?"Y":"N");	
		obj.InDateType.setValue(obj.chkoutDept.getValue()?"Y":"N");
			
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
		window.location.herf="dhcanrqueryrisk.csp";
		//alert(obj.InDateType.getValue());
	}
	OnMenuClick = function()
	{
	  	switch(arguments[0].id)
		{
		  	case "anrRiskOut":
		  		//alert("菜单功能正在开发")
		  		PrintAnOpList("SSFXPGDC","Y");
				break;
			default:
				break;
		}
	}
	obj.btnMedify_click = function()
	{			
        /*if(CheckNum()>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}*/
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{			
			var EpisodeID=selectObj.get('admId');
			var anrrDr=selectObj.get('anrrDr');
		}
		else 
		{
			ExtTool.alert("提示","请先选中一行！");
			return;
		}
		if (EpisodeID=="")
		{
			ExtTool.alert("提示","请先选中一行！");
			return;
		}		
		lnk= "dhcanrcrisk.csp?EpisodeID="+EpisodeID+"&anrrDr="+anrrDr
		window.open(lnk,"_self","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=900,width=1100,top=50,left=50");
	
	}
	obj.comAppLoc_select = function()
	{
		obj.loc.setValue(obj.comAppLoc.getValue());
	}

	obj.comAppLoc_keyup = function()
	{
		if(obj.comAppLoc.getRawValue()=="")
		obj.loc.setValue("");
	}

	obj.txtMedCareNo_keyup=function()
	{
		var digitReg=/^[0-9]\d*$/;
		var value=obj.txtMedCareNo.getValue();
		var n=obj.txtMedCareNo.lengthRange.max
		if(digitReg.exec(value))
		{
			var str0=""
			var len=value.length;
			if(value.substr(0,1)!=0) 
			{ 
				for(i=1;i<n-len+1;i++)
				{
					str0=str0+'0'
				}
				value=str0+value;
				if(value.length==n) obj.txtMedCareNo.setValue(value);
			}
			else
			{
				var sn=len-n;
				if(sn>=0)
				{
					value=value.substr(sn);
					if(value.length==n)
					obj.txtMedCareNo.setValue(value);
				}
				else 
				{ 
					var cn=n-len;
					for(j=1;j<cn+1;j++)
					{
						str0=str0+'0';
					}
					value=str0+value;
					if(value.length==n) obj.txtMedCareNo.setValue(value);
				}
			}
		}	
	}

	obj.date_blur=function IsValidDate(e)
	{
		var dt=e.value;
		//alert(dt);
		var re = /^(\s)+/ ; dt=dt.replace(re,'');
		var re = /(\s)+$/ ; dt=dt.replace(re,'');
		var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
		if (dt=='') {e.value=''; return 1;}
		re = /[^0-9A-Za-z]/g ;
		dt=dt.replace(re,'/');

		for (var i=0;i<dt.length;i++) {
			var type=dt.substring(i,i+1).toUpperCase();
			if (type=='T'||type=='W'||type=='M'||type=='Y') {
				if (type=='T') {return ConvertTDate(e);} else {return ConvertWMYDate(e,i,type);}
				break;
			}
		}
		if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
		var dtArr=dt.split('/');
		var len=dtArr.length;
		if (len>3) return 0;
		for (i=0; i<len; i++) {
			if (dtArr[i]=='') return 0;
		}
		var dy,mo,yr;
		for (i=len; i<3; i++) dtArr[i]='';
		dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
		if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
		if ((String(yr).length==4)&&(yr<1840)) return 0;
		var today=new Date();
		if (yr=='') {
			yr=today.getYear();
			if (mo=='') mo=today.getMonth()+1;
		}
		if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
		if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
		if (mo==2) {
			if (dy>29) return 0;
			if ((!isLeapYear(yr))&&(dy>28)) return 0;
		}
		if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
		if (isMaxedDate(dy,mo,yr)) return 0;
		e.value=ReWriteDate(dy,mo,yr);
		websys_returnEvent();
		return 1;
	}
	

function ReWriteDate(d,m,y) {
	y=parseInt(y,10);
	if (y<15) y+=2000; else if (y<100) y+=1900;
	if ((y>99)&&(y<1000)) y+=1900;
	if ((d<10)&&(String(d).length<2)) d='0'+d;
	if ((m<10)&&(String(m).length<2)) m='0'+m;
	var newdate='';
	newdate=d+'/'+m+'/'+y;
	return newdate;
}

	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
			var adm=selectObj.get('admId');
			obj.EpisodeID.setValue(adm);
			var EpisodeID=adm;
			var AnaesthesiaID="";
			AnaesthesiaID=selectObj.get('AnaesthesiaID');		
			var win=top.frames['eprmenu'];
			var isSet=false;
			if (win) {
				var frm = win.document.forms['fEPRMENU'];
				if (frm) {
					frm.PatientID.value = "";
					frm.EpisodeID.value =adm;
					if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;
					isSet=true;
				}
			}
			if (isSet==false)
			{
				var frm =dhcsys_getmenuform();
				if (frm) 
				{
					frm.EpisodeID.value=adm;
					if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;
				}
			}	
		}
	}

	
	obj.chkSelAll_check=function()
	{
		var val = arguments[1]
		obj.retGridPanelStore.each(function(record){
			record.set('checked', val);
		});
		//obj.retGridPanelStore.commitChanges();
	}
	function PrintAnOpList(prnType,exportFlag)
	{
		if (prnType=="") return;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		var printSTTitle="高血压|hypertension^冠心病|coronaryHeartDisease^陈旧心梗|BBACEIARB^心衰|HistoryOfHeartFailure^心脏症状|Nearly6monthHeartSymptoms^冠脉架/桥|CoronaryStent^心律失常|Arrhythmia^肝功能异常|ALTAbnor^COPD/哮喘|Asthma"
		printSTTitle=printSTTitle+"^吸烟未戒|Smoking^脑梗病史|HistoryOfCerebralInfarction^TIA发作|RecentOnsetOfTIA^CRF代偿期|CRFcompensatoryPeriod^CRF失代偿|CRFdecompensated^肾衰|renalFailure^糖尿病|diabetes^其他|other3"
		var sTTitleList=printSTTitle.split("^")
		var printSTLen=sTTitleList.length;
		path=GetFilePath();
		printTitle=_UDHCANOPSET.GetPrintTitle(prnType);
		var printStr=printTitle.split("!");
		if (printTitle.length<4) return;
		name=printStr[0];	
		fileName=printStr[1];
		fileName=path+fileName;		
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName) ;
		xlsSheet = xlsBook.ActiveSheet;
		operStat=printStr[2];
		var strList=printStr[3].split("^")
		var printLen=strList.length;
		for (var i=0;i<printLen;i++)
		{
			xlsSheet.cells(row,i+1)=strList[i].split("|")[0];
		}
		for(var z=0;z<printSTLen;z++)
		{
			xlsSheet.cells(row,printLen+z+1)=sTTitleList[z].split("|")[0];
		}
		var row=3;
		operNum=0;
		var preLoc="";
		var preRoom="";
		var count=obj.retGridPanelStore.getCount();//数据行数		
		//var selPrintTp=obj.chkSelPrint.getValue()?'S':'A';
		for (var i=0;i<count;i++)
		{
			var chk=""
			var record=obj.retGridPanelStore.getAt(i);
			//chk=record.get('checked');
			//var stat=record.get('status');
			//if (prnType=="SWD")
			//{
			   //if ((stat!="申请")&&(stat!="安排")&&(stat!="停止")&&(stat!="术中")) stat="完成" //ADD MFC 20130905
			//}
			//if (((selPrintTp=="A")&&((stat==operStat)||(operStat=="")))||((selPrintTp=="S")&&(chk==true)))
			//{
				row=row+1;
				operNum=operNum+1;
				//Sort by loc, insert empty row between different loc 
				//var loc=record.get('loc');
				//var locarr=loc.split("/");
				//if (locarr.length>1) loc=locarr[0];
				//var room=record.get('oproom');             //中国医大用，不同的手术间，插入一条空行，表头重新起。
				//if ((preRoom!="")&&(preRoom!=room))
				//{
				//	row=row+1;
					//for (var n=0;n<printLen;n++)
					//{
						//xlsSheet.cells(row,n+1)=strList[n].split("|")[0];
					//}
					//row=row+1;
				//}
				for(var j=0;j<printLen;j++)
				{
					var colName=strList[j].split("|")[1];
					var colVal=record.get(colName)
					if(colVal)
					{
							
						xlsSheet.cells(row,j+1)=colVal;
						
					}
					else xlsSheet.cells(row,j+1)="";
				}
				for(var k=0;k<printSTLen;k++)
				{
					//if (sTTitleList[k]=="") continue;					
					var retStr=_DHCANRRisk.GetRiskItemList(record.get('anrrDr'),session['LOGON.CTLOCID'],sTTitleList[k].split("|")[1]);			
					xlsSheet.cells(row,printLen+k+1)=retStr;
				}			
		}
		PrintTitle(xlsSheet,prnType,printStr,operNum,sTTitleList);
		titleRows=3;
		titleCols=1;
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
		ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		AddGrid(xlsSheet,3,0,row,printLen+printSTLen-1,3,1);
		FrameGrid(xlsSheet,3,0,row,printLen+printSTLen-1,3,1);
		if (exportFlag=="N")
		{
			//xlsExcel.Visible = true;
			//xlsSheet.PrintPreview;
			xlsSheet.PrintOut(); 
		}
		else
		{
			if (exportFlag=="Y")
			{
				var savefileName="C:\\Documents and Settings\\";
				var savefileName=_UDHCANOPSET.GetExportParth()
				var d = new Date();
				savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
				savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
				savefileName+=".xls"
				xlsSheet.SaveAs(savefileName);
				alert("文件已导入到"+savefileName);	
			}	
		}
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}

	function PrintTitle(objSheet,prnType,printStr,operNum,sTTitleList)
	{
		var sheetName=printStr[0];	
		var setList=printStr[3].split("^")		
		var colnum=setList.length+sTTitleList.length;
		var LocList=_DHCANRRisk.GetLocDesc(session['LOGON.CTLOCID'])
		if (LocList!="")
		{
			var Loc=LocList.split("^")
			LocDesc=Loc[0].split("-")
			LocDesc=LocDesc[1]
		}
		var hospitalDesc=_DHCANRRisk.GetHosNameByLoc(session['LOGON.CTLOCID'])
		mergcell(objSheet,1,1,colnum);
		xlcenter(objSheet,1,1,colnum);
		fontcell(objSheet,1,1,colnum,16);
		objSheet.cells(1,1)=hospitalDesc+LocDesc+sheetName;
		var operStartDate=obj.dateFrm.getRawValue();
		var tmpOperStartDate=operStartDate.split("/");
		if (tmpOperStartDate.length>2) operStartDate=tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+tmpOperStartDate[0]+" 日";
		mergcell(objSheet,2,1,colnum);
		fontcell(objSheet,2,1,colnum,10);
		objSheet.cells(2,1)=operStartDate;
		if (prnType=="SSD") objSheet.cells(2,1)=operStartDate+"                    "+'手术台数:'+" "+operNum;
		if (prnType=="MZD") objSheet.cells(2,1)=operStartDate;
	}

	function GetFilePath()
	{
		var path=_DHCANRRisk.GetPath();
		return path;
	}

	function GetComboxStoreDesc(value,store,descName,valueName)  
	{
		var index=store.find(valueName,value)
		store.load({});
		if(index!=-1)
		{
			return store.getAt(index).data[descName];
		}
		return value;
	}
	Ext.apply(Ext.form.VTypes,{
		lengthRange:function(val,field)
		{
			var minLength=0;
			var maxLength=10;
			if(field.lengthRange)
			{
				minLength=field.lengthRange.min;
				maxLength=field.lengthRange.max;		
			}
			if(val.length<minLength||val.length>maxLength)
			{
				if(minLength==0) field.vtypeText="您输入的长度必须小于"+maxLength+"!";
				else field.vtypeText="您输入的长度必须在"+minLength+"到"+maxLength+"之间!";
				return false;
			}
			return true;
		}
	})  
}



