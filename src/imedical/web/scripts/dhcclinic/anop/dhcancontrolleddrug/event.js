function InitViewScreenEvent(obj)
{	
	var _DHCANControlledDrug=ExtTool.StaticServerObject('web.DHCANControlledDrug');
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var intReg=/^[1-9]\d*$/;
	var logLocType="App";
	var idTmr=null;
	obj.LoadEvent = function(args)
	{
		var userId=session['LOGON.USERID'];
	  	var userType=_DHCANOPCom.GetUserType(userId);
	    var logUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
	    var sessLoc=session['LOGON.CTLOCID'];
	    var ret=_UDHCANOPSET.ifloc(sessLoc);
	    if ((ret!=1)&&(ret!=2))   //手术室:ret=1,麻醉科:ret=2
	    {
		    if(session['LOGON.GROUPID']==43 || session['LOGON.GROUPID']==45)
		    {
			    var PatWardDesc=(loc[0].split("-"))[1]
			    var PatWardId=_UDHCANOPArrange.GetcomPatWard(PatWardDesc);
			    obj.comPatWard.setValue(PatWardId);
			    obj.comPatWard.setRawValue(PatWardDesc);
		    }
		}
		else
		{
			if ((ret==1)&&(userType=="NURSE"))  logUserType="OPNURSE";
			if ((ret==2)&&(userType=="NURSE"))	logUserType="ANNURSE";
			if ((ret==2)&&(userType=="DOCTOR"))	logUserType="ANDOCTOR";
			if(ret==1) logLocType="OP";
			if(ret==2) logLocType="AN";
		}
		var ret=_DHCANOPCom.GetInitialDate(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateFrm.setValue(ret);
		obj.dateTo.setValue(ret);
		if(logLocType=="AN")
		{
			var ret=_DHCANOPCom.GetInitialDateTow(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
			obj.dateFrm.setValue(ret);
			obj.dateTo.setValue(ret);
		}
		var groupId=session['LOGON.GROUPID'];
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANControlledDrug';
			param.QueryName = 'GetToxicAnestList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			param.Arg4 = obj.comOpRoom.getValue();
			param.Arg5 = sessLoc;
			param.Arg6 = obj.txtMedCareNo.getValue();
			param.Arg7 = obj.comPatWard.getValue();
			param.Arg8 = logUserType;
			param.Arg9 = obj.txtRegNo.getValue();
			param.ArgCnt = 9;
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
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick=function()
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	    if (selectObj)
	    { 
		    
		    //obj.txtRegNo.setValue(selectObj.get("regNo"));
	        obj.opaId.setValue(selectObj.get("opaId"));
	    }
	}
	obj.retGridPanel_validateedit=function(ev)
	{
	}
	obj.retGridPanel_afteredit=function(ev)
	{
		var drugId="";
		var opaId=ev.record.data.opaId;
		var inputdrugId=ev.record.data.DrugDesc;
		if (inputdrugId!="")
		{
			var index = obj.DrugListStore.find('drugId',inputdrugId);
			if(index!=-1)
			{
				drugId=obj.DrugListStore.getAt(index).data.drugId;
			}
			else
			{
				var indexDesc = obj.DrugListStore.find('drugDesc',inputdrugId);
			    if(indexDesc!=-1)
			    {
				    drugId=obj.DrugListStore.getAt(indexDesc).data.drugId;
			    }
			}
		}
		var DrugAmount=ev.record.data.Quantity;
		var LotNumber=ev.record.data.BatchNo;
		var UsedQty=ev.record.data.usecount;
		var Disposal=ev.record.data.DisposalMeasures;
		var Note=ev.record.data.Note;
		var OrderDoc=ev.record.data.orderdoctor;
		var ret=_DHCANControlledDrug.UpdateDrugList(opaId,drugId,DrugAmount,LotNumber,UsedQty,Disposal,Note,OrderDoc);
		if(ev.field=='Handler')
		{
			var ctcpId=ev.value;
			var index = obj.NurseStore.find('ctcpId',ctcpId);
			if(index!=-1)
			{
				drugId=obj.NurseStore.getAt(index).data.ctcpId;
			}
			if(ev.originalValue!=ev.value)
			{
				if(ctcpId!="")
				{
					var ret=_DHCANControlledDrug.UpdateNurseList(opaId,ctcpId,"E");
				}
				else
				{
					obj.retGridPanelStore.reload();
				}
			}
		}
		if(ev.field=='Reviewer')
		{
			var ctcpId=ev.value;
			var index = obj.NurseStore.find('ctcpId',ctcpId);
			if(index!=-1)
			{
				drugId=obj.NurseStore.getAt(index).data.ctcpId;
			}
			if(ev.originalValue!=ev.value)
			{
				if(ctcpId!="")
				{
					var ret=_DHCANControlledDrug.UpdateNurseList(opaId,ctcpId,"C");
				}
				else
				{
					obj.retGridPanelStore.reload();
				}
			}
		}
		if(ev.field=='Recipient')
		{
			var ctcpId=ev.value;
			var index = obj.NurseStore.find('ctcpId',ctcpId);
			if(index!=-1)
			{
				drugId=obj.NurseStore.getAt(index).data.ctcpId;
			}
			if(ev.originalValue!=ev.value)
			{
				if(ctcpId!="")
				{
					var ret=_DHCANControlledDrug.UpdateNurseList(opaId,ctcpId,"D");
				}
				else
				{
					obj.retGridPanelStore.reload();
				}
			}
		}
		obj.retGridPanelStore.reload();
	}
	
	obj.btnExport_click = function()
	{
		ExportCDD();	  
	}
	function GetFilePath()
	{
		var path=_DHCLCNUREXCUTE.GetPath();
		return path;
	}
   function ExportCDD()
    {
	    var name,fileName,path,operStat,printTitle;
	    var xlsExcel,xlsBook,xlsSheet,titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	    path=GetFilePath();
	    fileName=path+"DHCANOPControlledDrug.xlsx";
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName);
	    xlsSheet = xlsBook.ActiveSheet;
	    printLen=30
	    row=0
	    var count = obj.retGridPanelStore.getCount();
	    for(var i=0;i<count;i++)
	    {
	        var record = obj.retGridPanelStore.getAt(i);
			row=row+1;
			var opdate="",comOpRoom="",regNo="",patName="",sex="",age="",PDVAnumber="",diag="",Note="",opaId=""
		    var DrugDesc="",Specification="",Unit="",Quantity="",BatchNo="",orderdoctor="",usecount="",DisposalMeasures="",Handler="",Reviewer="",Recipient=""
		    var opdate=record.get('opdate');
			var comOpRoom=record.get('comOpRoom');
			var regNo=record.get('regNo'); 
			var patName=record.get('patName'); 
			var sex=record.get('sex');
			var age=record.get('age');
			var PDVAnumber=record.get('PDVAnumber');
			var diag=record.get('diag');
			var Note=record.get('Note');
			var opaId=record.get('opaId');
			var DrugDesc=record.get('DrugDesc');
			var Specification=record.get('Specification');
			var Unit=record.get('Unit');
			var Quantity=record.get('Quantity');
			var BatchNo=record.get('BatchNo');
			var orderdoctor=record.get('orderdoctor');
			var usecount=record.get('usecount');
			var DisposalMeasures=record.get('DisposalMeasures');
			var HandlerID=record.get('Handler');
			var index = obj.NurseStore.find('ctcpId',HandlerID);
			if(index!=-1)
			{
				Handler=obj.NurseStore.getAt(index).data.ctcpDesc;
			}
			var ReviewerID=record.get('Reviewer');
			var index = obj.NurseStore.find('ctcpId',ReviewerID);
			if(index!=-1)
			{
				Reviewer=obj.NurseStore.getAt(index).data.ctcpDesc;
			}
			var RecipientID=record.get('Recipient');
			var index = obj.NurseStore.find('ctcpId',RecipientID);
			if(index!=-1)
			{
				Recipient=obj.NurseStore.getAt(index).data.ctcpDesc;
			}
			xlsSheet.cells(1,1)="青大附院毒麻药回收统计";
			xlsSheet.cells(2,1)="使用日期";
			xlsSheet.cells(2,2)="手术间";
			xlsSheet.cells(2,3)="病历登记号";
			xlsSheet.cells(2,4)="患者姓名";
			xlsSheet.cells(2,5)="性别";
			xlsSheet.cells(2,6)="年龄";
			xlsSheet.cells(2,7)="身份证编号";
			xlsSheet.cells(2,8)="临床诊断";
		    xlsSheet.cells(2,9)="药品名称";
			xlsSheet.cells(2,10)="规格";
			xlsSheet.cells(2,11)="单位";
			xlsSheet.cells(2,12)="数量";
			xlsSheet.cells(2,13)="批号";
			xlsSheet.cells(2,14)="处方医师";
			xlsSheet.cells(2,15)="用药量";
			xlsSheet.cells(2,16)="残余药液处置措施";
			xlsSheet.cells(2,17)="执行人";
			xlsSheet.cells(2,18)="复核人";
			xlsSheet.cells(2,19)="空安瓿回收(接收人)";
			xlsSheet.cells(2,20)="备注";
			
			xlsSheet.cells(3+(row-1),1)=opdate;
			xlsSheet.cells(3+(row-1),2)=comOpRoom;
			xlsSheet.cells(3+(row-1),3)=regNo;
			xlsSheet.cells(3+(row-1),4)=patName;
			xlsSheet.cells(3+(row-1),5)=sex;	
			xlsSheet.cells(3+(row-1),6)=age;
			xlsSheet.cells(3+(row-1),7)=PDVAnumber;
			xlsSheet.cells(3+(row-1),8)=diag;
			xlsSheet.cells(3+(row-1),9)=DrugDesc;
			xlsSheet.cells(3+(row-1),10)=Specification;
			xlsSheet.cells(3+(row-1),11)=Unit;
			xlsSheet.cells(3+(row-1),12)=Quantity;	
			xlsSheet.cells(3+(row-1),13)=BatchNo;
			xlsSheet.cells(3+(row-1),14)=orderdoctor;
			xlsSheet.cells(3+(row-1),15)=usecount;
			xlsSheet.cells(3+(row-1),16)=DisposalMeasures;		
			xlsSheet.cells(3+(row-1),17)=Handler;
			xlsSheet.cells(3+(row-1),18)=Reviewer;
			xlsSheet.cells(3+(row-1),19)=Recipient;
			xlsSheet.cells(3+(row-1),20)=Note;
		}
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
		titleRows = 0,titleCols = 0,LeftHeader = " ",CenterHeader = " ",
		RightHeader = " ",LeftFooter = "",CenterFooter = "",RightFooter = " &N - &P ";
		xlsExcel.Visible = true;
    }
}