document.body.onload=Init;

var BuildEnabledFlag=false;
var StopStr=""; 

function Init() {
	var obj=document.getElementById('Add');
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById('Save');
	if (obj) obj.onclick=SaveClickHandler;
	var obj=document.getElementById('Build');
	if (obj) obj.onclick=BuildClickHandler;
	var obj=document.getElementById('BtnPrintPre');
	if (obj) obj.onclick=BtnPrintPreHandler;
	var obj=document.getElementById('CancelSheet');
	if (obj) obj.onclick=CancelClickHandler;   
	var obj=document.getElementById('Modify');
	if (obj) obj.onclick=ModifyClickHandler; 
	var obj=document.getElementById('Change');
	if (obj) obj.onclick=ChangeClickHandler; 	
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	var SheetEpisodeID=DHCC_GetElementData('SheetEpisodeID');
	var SheetRowId=DHCC_GetElementData('SheetRowId');
	var CopySheetRowId=DHCC_GetElementData('CopySheetRowId');
	var CurrentSheetRowId=DHCC_GetElementData('CurrentSheetRowId');
	var obj=document.getElementById('ModifyFlag');
	if (obj) ModifyFlag=obj.value
	var obj=document.getElementById('ChangeFlag');
	if (obj) ChangeFlag=obj.value
	
	DHCC_SetElementData("Cycle",CurrentCycle);
	//alert("EpisodeID="+EpisodeID);  
	//alert("SheetEpisodeID="+SheetEpisodeID);	
	//alert("SheetRowId="+SheetRowId);
	//alert("CopySheetRowId="+CopySheetRowId);
	//alert("CurrentSheetRowId="+CurrentSheetRowId);
	if (CopySheetRowId!=""){
		cspRunServerMethod(GetDetailMethod,"CopyGroupDetail","",CopySheetRowId);
	}else{
		 if (SheetRowId==""){
			 AddGroupDIVToCell(1);
			 websys_setfocus("tGroup1"+"OrderNamez1");
		 }else{
		 		if (ModifyFlag!=""){
		 			cspRunServerMethod(GetDetailMethod,"AddGroupDetail","",SheetRowId);
		 		}else{
		 			if (ChangeFlag!=""){
		 				cspRunServerMethod(GetDetailMethod,"ChangeGroupDetail","",SheetRowId);
		 			}else{
		   				cspRunServerMethod(GetDetailMethod,"ReadonlyGroupDetail","",SheetRowId);
		   		}
		   	}
		 }
	} 
	SetTableColor();
	var PreveiwFlag=0;
	var Parobj=window.opener
	if (Parobj)  PreveiwFlag=1;
	BtnControl(SheetRowId,SheetStatus,PreveiwFlag,ModifyFlag,ChangeFlag);

	DHCP_GetXMLConfig("XMLObject","YKYZLYYChemotherapy");
}

function BtnControl(SheetRowId,SheetStatus,PreveiwFlag,ModifyFlag,ChangeFlag) {
	//   控制按钮可用与否,控制流程
	var obj=document.getElementById('Add');
	if (obj){
		obj.disabled=true;
		obj.onclick="";
	}		
	var obj=document.getElementById('SheetRemark');
	if (obj){
		obj.disabled=true;
	}			
	var obj=document.getElementById('BtnPrintPre');
	if (obj){
		obj.onclick="";
		obj.disabled=true
	}	
	var obj=document.getElementById('Save');
	if (obj){
		obj.disabled=true;
		obj.onclick="";
	}	
	var obj=document.getElementById('Build');
	if (obj){
		obj.onclick="";
		obj.disabled=true
	}	
	var obj=document.getElementById('Modify');
	if (obj){
		obj.onclick="";
		obj.disabled=true
	}
	var obj=document.getElementById('Change');
	if (obj){
		obj.onclick="";
		obj.disabled=true
	}		
	var obj=document.getElementById('CancelSheet');
	if (obj){
		obj.onclick="";
		obj.disabled=true
	}	
	if (LockedFlag==1) {
	// 如果该病人记录被锁定,则界面不可操作
		var obj=document.getElementById('Find');
		if (obj){
			obj.onclick="";
			obj.disabled=true
		}	
		return;
	}
	if (SheetRowId==""){
	//"新建"界面(包括通过复制其他的化疗单新建),允许下列操作:增加组,保存
		var obj=document.getElementById('Add');
		if (obj){
			obj.disabled=false;
			obj.onclick=AddClickHandler;
		}
		var obj=document.getElementById('SheetRemark');
		if (obj){
			obj.disabled=false;
		}			
		var obj=document.getElementById('Save');
		if (obj){
			obj.disabled=false;
			obj.onclick=SaveClickHandler;
		}		
	}else{
		if ((ModifyFlag=="")&&(ChangeFlag=="")&&(PreveiwFlag=="")){
		//"显示"界面,根据化疗单的状态,允许如下操作:
			var obj=document.getElementById('BtnPrintPre');
			if (obj){
				obj.onclick=BtnPrintPreHandler;
				obj.disabled=false;
			}
			var obj=document.getElementById('CancelSheet');
			if (obj){
				obj.onclick=CancelClickHandler;
				obj.disabled=false;
			}
			var obj=document.getElementById('Change');
			if (obj){
				obj.onclick=ChangeClickHandler;
				obj.disabled=false;
			}
			/*								
			var SheetStartFlag=GetSheetStartFlag();
			if ((SheetStatus=="P")||(SheetStatus=="C")||(SheetStartFlag>=0)){	
			//已生成处方,或化疗单调整过,或化疗已经开始执行,允许"调整化疗计划"
				var obj=document.getElementById('Change');
				if (obj){
					obj.onclick=ChangeClickHandler;
					obj.disabled=false;
				}								
			}
			if ((SheetStatus!="P")&&(SheetStatus!="C")&&(SheetStartFlag<=0)){	
			//未生成处方,而且未"调整化疗单",而且化疗还未开始执行,允许"修改化疗单"	
				var obj=document.getElementById('Modify');
				if (obj){
					obj.onclick=ModifyClickHandler; 
					obj.disabled=false;
				}								
			}
			*/
			if (BuildEnabledFlag==true){
			//如果有的未生成处方的药,允许"生成处方"
				var obj=document.getElementById('Build');
				if (obj){
					obj.onclick=BuildClickHandler;
					obj.disabled=false;
				}
			}	
		}
		if ((ModifyFlag==1)||(ChangeFlag==1)){
		//"修改"界面,允许下列操作:增加组,保存
			var obj=document.getElementById('Add');
			if (obj){
				obj.disabled=false;
				obj.onclick=AddClickHandler;
			}
			var obj=document.getElementById('SheetRemark');
			if (obj){
				obj.disabled=false;
			}			
			var obj=document.getElementById('Save');
			if (obj){
				obj.disabled=false;
				obj.onclick=SaveClickHandler;
			}				
		}
		if (PreveiwFlag!=""){
			var obj=document.getElementById('Find');
			if (obj){
				obj.disabled=true;
				obj.onclick="";
			}	
			var obj=document.getElementById('BtnPrintPre');
			if (obj){
				obj.onclick=BtnPrintPreHandler;
				obj.disabled=false;
			}	
		}
	}
}	

function SheetRemark_keydownhandler(){
  return;
}
function SheetLog_keydownhandler(){
  return;
}

function GetSheetStartFlag(){
	var Today=GetToday();
	var SheetStartDate=DHCC_GetElementData("StartDate");
	var TodayVal=cspRunServerMethod(ConverDateMethod,Today,1);
	var SheetStartDateVal=cspRunServerMethod(ConverDateMethod,SheetStartDate,3);
	if (SheetStartDateVal>TodayVal){
		var SheetStartFlag=-1;
	}else{
		if (SheetStartDateVal==TodayVal){
			var SheetStartFlag=0;
		}else{
			var SheetStartFlag=1;
		}
	}
	return SheetStartFlag;
}

function SelectRowHandler()	{
	var PatientID=DHCC_GetElementData('PatientID');
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	//var mradm=DHCC_GetElementData('EpisodeID');
	var win=top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
    if (frm) {
			frm.EpisodeID.value = EpisodeID;
			frm.PatientID.value=PatientID;
			//frm.mradm.value=mradm;
    }
	}
}
	
function CopyGroupDetail(GroupStr){
	var objtbl=document.getElementById("tDHCPAAdmSheet_Edit");
	var rows=objtbl.rows.length;
	if (rows==2){
		var SheetGroupCell=GetCellObj("SheetGroup",1);
		if (SheetGroupCell.innerHTML!="&nbsp;"){
			AddNewRow(objtbl);
		}
	}else{
		AddNewRow(objtbl);
	}
	var Row=objtbl.rows.length-1;
	var SheetGroupCell=GetCellObj("SheetGroup",Row);
	var SheetGroup = document.createElement("DIV");
	SheetGroup.id="SheetGroup"+Row; 
	
	//SheetGroup.className = 'dhx_combo_list';
	//SheetGroup.style.width=parseInt(this.offsetWidth)+"px";
	var GroupId="tGroup"+Row;
	var GroupMId="tGroupM"+Row;
	var GroupDId="tGroupD"+Row;
	SheetGroup.style.width="1000px"
	SheetGroup.style.overflow="auto";      
	//SheetGroup.style.display = "block"; //block
	var innerHTMLs="<SPAN class='chartitemheading' id='GroupTitle'><IMG id='IMGZ0A1' src='../images/websys/minus.gif' border=0>&nbsp;<B>第"+Row+"组</B></SPAN>";
	innerHTMLs=innerHTMLs+'<TD >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+GroupId+'VenousFillingFlag" name="'+GroupId+'VenousFillingFlag" Style="WIDTH: 30px; HEIGHT: 22px" type="checkbox" onclick=\"VenousFillingFlagChangehandler()\">&nbsp;<B>建立静脉通道</B></input></TD>';
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupMId+'" Name="'+GroupMId+'" CELLSPACING=1 width="100%">';
	
	innerHTMLs=innerHTMLs+'<TR NOWRAP><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupId+'" Name="'+GroupId+'" CELLSPACING=1 width="100%" onclick="GroupItemSelectRow()">';
	innerHTMLs=innerHTMLs+'<THEAD>';
	innerHTMLs=innerHTMLs+"<TH id=1  NOWRAP>序号</TH>";
	innerHTMLs=innerHTMLs+"<TH id=2  NOWRAP>药品名称</TH>";
	innerHTMLs=innerHTMLs+"<TH id=3  NOWRAP>单次剂量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=4  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=5  NOWRAP>频次</TH>";
	innerHTMLs=innerHTMLs+"<TH id=6  NOWRAP>用法</TH>";
	innerHTMLs=innerHTMLs+"<TH id=7  NOWRAP>通道液</TH>";
	innerHTMLs=innerHTMLs+"<TH id=8  NOWRAP>单价</TH>";
	innerHTMLs=innerHTMLs+"<TH id=9  NOWRAP>备注</TH>";
	innerHTMLs=innerHTMLs+"<TH id=10  NOWRAP>取药数量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=11  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=12  NOWRAP>费别</TH>";
	innerHTMLs=innerHTMLs+"<TH id=13  NOWRAP>处方</TH>";
	innerHTMLs=innerHTMLs+"<TH id=14  NOWRAP>提示</TH>";
	innerHTMLs=innerHTMLs+"<TH id=15  NOWRAP>合计</TH>";
	innerHTMLs=innerHTMLs+"<TH id=16  NOWRAP>接收科室</TH>";
	innerHTMLs=innerHTMLs+"</THEAD>";
	innerHTMLs=innerHTMLs+"<TBODY>";
	
	var TempGroupStr=GroupStr.split(String.fromCharCode(3));
	var GroupStr=TempGroupStr[0];
	var GroupRemark=TempGroupStr[1];	//化疗单备注	
	var ExecuteDate=TempGroupStr[2];	//化疗日期
	var SubGroupRemark=TempGroupStr[3];	//组备注
	var SheetRemarkObj=document.getElementById('SheetRemark')
	if (SheetRemarkObj)SheetRemarkObj.value=GroupRemark
	var SubGroupStr=GroupStr.split(String.fromCharCode(1));
	
	for (var j=1;j<=SubGroupStr.length;j++) {
		var k=j-1
		SubGroupItem=SubGroupStr[k].split("^");
		var OrderName=SubGroupItem[0];
		var OrderDoseQty=SubGroupItem[1];
		var OrderDoseUOM=SubGroupItem[2];
		var OrderFreq=SubGroupItem[3];
		var OrderInstr=SubGroupItem[4];
		var OrderPrice=SubGroupItem[5];
		var OrderDepProcNote=SubGroupItem[6];
		var OrderPackQty=SubGroupItem[7];
		var OrderPackUOM=SubGroupItem[8];
		var OrderBillType=SubGroupItem[9];
		var OrderMsg=SubGroupItem[10];
		var OrderSum=SubGroupItem[11];
		var OrderRecDep=SubGroupItem[12];
		;//Hidden Item
		var OrderItemRowid=SubGroupItem[13];    //
		//var OrderPriorRowid=SubGroupItem[14];   //
		var OrderPriorRowid=DefaultOrderPriorRowid;   //
		var OrderARCIMRowid=SubGroupItem[15];   //
		var OrderType=SubGroupItem[16];
		var OrderDoseUOMRowid=SubGroupItem[17]; //
		var OrderInstrRowid=SubGroupItem[18];   //
		var OrderFreqRowid=SubGroupItem[19];    //
		var OrderFreqFactor=SubGroupItem[20];
		var OrderFreqInterval=SubGroupItem[21]; 
		var OrderRecDepRowid=SubGroupItem[22];  //
		var OrderBillTypeRowid=SubGroupItem[23] // 
		var OrderPackUOMRowid=SubGroupItem[24]; //
		var OrderConFac=SubGroupItem[25];				//*
		var OrderBaseQtySum=SubGroupItem[26];
		var OrderBaseQty=SubGroupItem[27]				
		var OrderPHPrescType=SubGroupItem[28]		
		var OrderPHForm=SubGroupItem[29];
		var OrderDrugFormRowid=SubGroupItem[30];
		var OrderMaxQty=SubGroupItem[31];				//*
		var OrderAlertStockQty=SubGroupItem[32];
		var OrderPoisonCode=SubGroupItem[33];		//*
		var OrderHiddenPara=SubGroupItem[34];
		//var SheetItemRowid=SubGroupItem[35];
		var VenousFillingFlag=SubGroupItem[41];
		var SolventFlag=SubGroupItem[42];
		var SheetItemRowid="";
		if(OrderFreqInterval>1){
			OrderFreq="";
			OrderFreqRowid="";
			OrderFreqFactor="";
			OrderFreqInterval="";
		}
		
		innerHTMLs=innerHTMLs+'<TR class="RowOdd" NOWRAP>';
		innerHTMLs=innerHTMLs+'<TD style="display:none;">';
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderItemRowidz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPriorRowidz"+j,OrderPriorRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCIMRowidz"+j,OrderARCIMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderTypez"+j,OrderType); 
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDoseUOMRowidz"+j,OrderDoseUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqRowidz"+j,OrderFreqRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderInstrRowidz"+j,OrderInstrRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurFactorz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz"+j,OrderFreqFactor);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqIntervalz"+j,OrderFreqInterval);
		//innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz"+j,"");
 		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurFactorz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderConFacz"+j,OrderConFac);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPackUOMRowidz"+j,OrderPackUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtyz"+j,OrderBaseQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtySumz"+j,OrderBaseQtySum);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHFormz"+j,OrderPHForm);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHPrescTypez"+j,OrderPHPrescType);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDrugFormRowidz"+j,OrderDrugFormRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBillTypeRowidz"+j,OrderBillTypeRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderRecDepRowidz"+j,OrderRecDepRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCOSRowidz1","");
 		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxDurFactorz1","");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxQtyz"+j,OrderMaxQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderAlertStockQtyz"+j,OrderAlertStockQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPoisonCodez"+j,OrderPoisonCode);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderHiddenParaz"+j,OrderHiddenPara);
		//innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemRowidz"+j,SheetItemRowid);
		innerHTMLs=innerHTMLs+'</TD>';

		//innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 20px; HEIGHT: 22px">';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSeqNoz"+j,20,j);
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderNamez"+j,OrderName,230,"xItem_lookuphandler()","");
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><input id="'+GroupId+'OrderDoseQtyz'+j+'" name="'+GroupId+'OrderDoseQtyz'+j+'" value="'+OrderDoseQty+'" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderDoseQtychangehandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">&nbsp;</input></TD>';
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderDoseUOMz'+j+'" name="'+GroupId+'OrderDoseUOMz'+j+'" value="'+OrderDoseUOM+'" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderDoseUOMchangehandler()\">&nbsp;</select></TD>';
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderFreqz"+j,OrderFreq,70,"PHCFRDesc_lookuphandler()","FrequencyChangeHandler()");
 		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderInstrz"+j,OrderInstr,70,"PHCINDesc_lookuphandler()","InstrChangeHandler()");
 		if(SolventFlag=="Y"){
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled CHECKED type="checkbox"></input></TD>';
		}else{
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
		}
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPricez"+j,50,OrderPrice);
		innerHTMLs=innerHTMLs+InputCellHtml(GroupId+"OrderDepProcNotez"+j,50,OrderDepProcNote);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackQtyz"+j,50,OrderPackQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackUOMz"+j,50,OrderPackUOM);
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderBillTypez"+j,OrderBillType,100,"BillType_lookup()","");
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED type="checkbox"></input></TD>';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderMsgz"+j,150,OrderMsg);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSumz"+j,50,OrderSum);
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderRecDepz'+j+'" name="'+GroupId+'OrderRecDepz'+j+'" Style="WIDTH: 150px; HEIGHT: 22px" onchange=\"OrderRecDepchangehandler()\">&nbsp;</select></TD>';
		innerHTMLs=innerHTMLs+"</TR>";
		//innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"SheetItemRowidz"+j,100,SheetItemRowid);
		innerHTMLs=innerHTMLs+"</TR>";
	}
	innerHTMLs=innerHTMLs+"</TBODY>";
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>'; 
	
	innerHTMLs=innerHTMLs+'<TR><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList  id="'+GroupDId+'" Name="'+GroupDId+'" CELLSPACING=1 width="100%">';
	innerHTMLs=innerHTMLs+'<TR">'; 
	innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期</TD>';
	innerHTMLs=innerHTMLs+LookupCellReadonlyHtml(GroupId+"MultiDate","",630,"MultiDateClickhandler()","");
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+'<TR >'; 
	innerHTMLs=innerHTMLs+'<TD width=10%">组备注信息</TD><TD width=90%><input id="'+GroupId+'Remark" name="'+GroupId+'Remark" value="'+SubGroupRemark+'" Style="HEIGHT: 22px; WIDTH:800px""></input></TD>';
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>';
	
	innerHTMLs=innerHTMLs+"</TABLE>";
  innerHTMLs=innerHTMLs+"<SPAN class='chartitemheading'>&nbsp;<A HREF='#' id='"+GroupId+"AddGroupItem' onclick='AddGroupItem("+Row+");'><IMG SRC='../images/websys/new.gif' BORDER=0>增加药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"DeleteGroupItem' onclick='DeleteGroupItem("+Row+");'><IMG SRC='../images/websys/delete.gif'BORDER=0>删除药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='ShowRemark("+Row+");'><IMG SRC='../images/websys/new.gif'BORDER=0>录入备注</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroupItem();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroupItem();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='DeleteGroup' onclick='DeleteGroup();'><IMG SRC='../images/websys/delete.gif' BORDER=0><B>删除组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroup();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroup();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移组</B></A></SPAN>";
	SheetGroupCell.innerHTML=innerHTMLs;
	if (VenousFillingFlag=="Y") {
		DHCC_SetElementData(GroupId+"VenousFillingFlag",true);
		ChangeSolventFlag(GroupId);
	}else{
		DHCC_SetElementData(GroupId+"VenousFillingFlag",false);
	}
	
	for (var j=1;j<=SubGroupStr.length;j++){
		SetNewColumnList(1,GroupId,j,1)
	}
}

function SetNewColumnList(EditFlag,GroupId,FocusRowIndex,BillTypeFlag){
	var OrderDoseQty=GetColumnData(GroupId,"OrderDoseQty",FocusRowIndex); 
	var OrderDoseUOMRowid=GetColumnData(GroupId,"OrderDoseUOMRowid",FocusRowIndex);
	var OrderDoseUOM=GetColumnData(GroupId,"OrderDoseUOM",FocusRowIndex);
	var OrderRecDep=GetColumnData(GroupId,"OrderRecDep",FocusRowIndex);
	var OrderRecDepRowid=GetColumnData(GroupId,"OrderRecDepRowid",FocusRowIndex);
	var OrderMsg=GetColumnData(GroupId,"OrderMsg",FocusRowIndex);

	var OrderARCIMRowid=GetColumnData(GroupId,"OrderARCIMRowid",FocusRowIndex);
	EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetailMehtod,EpisodeID,"","",OrderARCIMRowid);
	var ireclocstr=mPiece(EPARCIMDetail,"^",9);
	var idoseqtystr=mPiece(EPARCIMDetail,"^",11);
	SetColumnList(GroupId,"OrderDoseUOM",FocusRowIndex,idoseqtystr)
	SetColumnList(GroupId,"OrderRecDep",FocusRowIndex,ireclocstr)
	
	SetColumnData(GroupId,"OrderDoseQty",FocusRowIndex,OrderDoseQty);
	SetColumnData(GroupId,"OrderDoseUOM",FocusRowIndex,OrderDoseUOMRowid);
	SetColumnData(GroupId,"OrderDoseUOMRowid",FocusRowIndex,OrderDoseUOMRowid); 
	SetColumnData(GroupId,"OrderRecDep",FocusRowIndex,OrderRecDepRowid);
	SetColumnData(GroupId,"OrderRecDepRowid",FocusRowIndex,OrderRecDepRowid);
	
	// 复制的化疗单,费别根据病人身份重新取
	var BillType="",BillTypeRowId="";
	var BillTypeStr=cspRunServerMethod(GetDefaultBillTypeMethod,EpisodeID,OrderARCIMRowid);
	var BillTypeNum=mPiece(BillTypeStr,"^",2);
	
	if (BillTypeFlag==1){
		if ((OrderMsg=="")||(BillTypeNum==1)) {
		 	var BillTypeRowId=mPiece(BillTypeStr,"^",0);
		 	var BillType=mPiece(BillTypeStr,"^",1);
	  }
		SetColumnData(GroupId,"OrderBillType",FocusRowIndex,BillType);
		SetColumnData(GroupId,"OrderBillTypeRowId",FocusRowIndex,BillTypeRowId);		
	}
}

function InputCellHtml(cellid,cellwidth,txt){
	var inputwidth=cellwidth;
	var str='<TD  STYLE="WIDTH: '+cellwidth+'px; HEIGHT: 22px">';
	var str=str+'<input id=\"'+cellid+'\" name=\"'+cellid+'\" value="'+txt+'" Style="WIDTH:'+inputwidth+'px; HEIGHT: 22px"></label>';
	var str=str+'</TD>';
	return str;
}

function ReadonlyGroupDetail(GroupStr){
	var objtbl=document.getElementById("tDHCPAAdmSheet_Edit");
	var rows=objtbl.rows.length;
	if (rows==2){
		var SheetGroupCell=GetCellObj("SheetGroup",1);
		if (SheetGroupCell.innerHTML!="&nbsp;"){
			AddNewRow(objtbl);
		}
	}else{
		AddNewRow(objtbl);
	}
	var Row=objtbl.rows.length-1;
	var SheetGroupCell=GetCellObj("SheetGroup",Row);
	var SheetGroup = document.createElement("DIV");
	SheetGroup.id="SheetGroup"+Row; 
	//SheetGroup.className = 'dhx_combo_list';
	
	//SheetGroup.style.width=parseInt(this.offsetWidth)+"px";
	var GroupId="tGroup"+Row;
	var GroupMId="tGroupM"+Row;
	var GroupDId="tGroupD"+Row;
	SheetGroup.style.width="1000px"
	SheetGroup.style.overflow="auto";      
	//SheetGroup.style.display = "block"; //block
	var innerHTMLs="<SPAN class='chartitemheading' id='GroupTitle'><IMG id='IMGZ0A1' src='../images/websys/minus.gif' border=0>&nbsp;<B>第"+Row+"组</B></SPAN>";
	innerHTMLs=innerHTMLs+'<TD >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+GroupId+'VenousFillingFlag" name="'+GroupId+'VenousFillingFlag" Style="WIDTH: 30px; HEIGHT: 22px" type="checkbox" disabled onclick=\"VenousFillingFlagChangehandler()\">&nbsp;<B>建立静脉通道</B></input></TD>';
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupMId+'" Name="'+GroupMId+'" CELLSPACING=1 width="100%">';
	
	innerHTMLs=innerHTMLs+'<TR NOWRAP><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupId+'" Name="'+GroupId+'" CELLSPACING=1 width="100%" onclick="GroupItemSelectRow()">';
	innerHTMLs=innerHTMLs+'<THEAD>';
	innerHTMLs=innerHTMLs+"<TH id=1  NOWRAP>序号</TH>";
	innerHTMLs=innerHTMLs+"<TH id=2  NOWRAP>药品名称</TH>";
	innerHTMLs=innerHTMLs+"<TH id=3  NOWRAP>单次剂量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=4  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=5  NOWRAP>频次</TH>";
	innerHTMLs=innerHTMLs+"<TH id=6  NOWRAP>用法</TH>";
	innerHTMLs=innerHTMLs+"<TH id=7  NOWRAP>通道液</TH>";
	innerHTMLs=innerHTMLs+"<TH id=8  NOWRAP>单价</TH>";
	innerHTMLs=innerHTMLs+"<TH id=9  NOWRAP>备注</TH>";
	innerHTMLs=innerHTMLs+"<TH id=10  NOWRAP>取药数量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=11  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=12  NOWRAP>费别</TH>";
	innerHTMLs=innerHTMLs+"<TH id=13  NOWRAP>处方</TH>";
	innerHTMLs=innerHTMLs+"<TH id=14  NOWRAP>提示</TH>";
	innerHTMLs=innerHTMLs+"<TH id=15  NOWRAP>合计</TH>";
	innerHTMLs=innerHTMLs+"<TH id=16  NOWRAP>接收科室</TH>";
	innerHTMLs=innerHTMLs+"<TH id=17  NOWRAP>停止日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=18  NOWRAP>新增日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=19  NOWRAP>计费状态</TH>";
	innerHTMLs=innerHTMLs+"</THEAD>";
	innerHTMLs=innerHTMLs+"<TBODY>";
	var TempGroupStr=GroupStr.split(String.fromCharCode(3));
	var GroupStr=TempGroupStr[0];
	var GroupRemark=TempGroupStr[1];	//化疗单备注	
	var ExecuteDate=TempGroupStr[2];	//化疗日期
	var SubGroupRemark=TempGroupStr[3];	//组备注
	var LogStr=TempGroupStr[4];        //日志
	var SheetRemarkObj=document.getElementById('SheetRemark')
	if (SheetRemarkObj)SheetRemarkObj.value=GroupRemark
	var SheetLogObj=document.getElementById('SheetLog')
	if (SheetLogObj)SheetLogObj.value=LogStr
	var SubGroupStr=GroupStr.split(String.fromCharCode(1));
	var GroupStatus="";
	for (var j=1;j<=SubGroupStr.length;j++) {
		var k=j-1
		SubGroupItem=SubGroupStr[k].split("^");
		var OrderName=SubGroupItem[0];
		var OrderDoseQty=SubGroupItem[1];
		var OrderDoseUOM=SubGroupItem[2];
		var OrderFreq=SubGroupItem[3];
		var OrderInstr=SubGroupItem[4];
		var OrderPrice=SubGroupItem[5];
		var OrderDepProcNote=SubGroupItem[6];
		var OrderPackQty=SubGroupItem[7];
		var OrderPackUOM=SubGroupItem[8];
		var OrderBillType=SubGroupItem[9];
		var OrderMsg=SubGroupItem[10];
		var OrderSum=SubGroupItem[11];
		var OrderRecDep=SubGroupItem[12];
		;//Hidden Item
		var OrderItemRowid=SubGroupItem[13];    //
		var OrderPriorRowid=SubGroupItem[14];   //
		var OrderARCIMRowid=SubGroupItem[15];   //
		var OrderType=SubGroupItem[16];
		var OrderDoseUOMRowid=SubGroupItem[17]; //
		var OrderInstrRowid=SubGroupItem[18];   //
		var OrderFreqRowid=SubGroupItem[19];    //
		var OrderFreqFactor=SubGroupItem[20];
		var OrderFreqInterval=SubGroupItem[21];
		var OrderRecDepRowid=SubGroupItem[22];  //
		var OrderBillTypeRowid=SubGroupItem[23]  //
		var OrderPackUOMRowid=SubGroupItem[24]; //
		var OrderConFac=SubGroupItem[25];
		var OrderBaseQtySum=SubGroupItem[26];
		var OrderBaseQty=SubGroupItem[27]
		var OrderPHPrescType=SubGroupItem[28]
		var OrderPHForm=SubGroupItem[29];
		var OrderDrugFormRowid=SubGroupItem[30];
		var OrderMaxQty=SubGroupItem[31];
		var OrderAlertStockQty=SubGroupItem[32];
		var OrderPoisonCode=SubGroupItem[33];
		var OrderHiddenPara=SubGroupItem[34];
		var SheetItemRowid=SubGroupItem[35];
		var OrderPrescNo=SubGroupItem[36];
		var SheetItemStatus=SubGroupItem[37];
		var OrderItemStopDate=SubGroupItem[38];
		var OrderItemAddDate=SubGroupItem[39];
		var OrderItemBilled=SubGroupItem[40];
		var VenousFillingFlag=SubGroupItem[41];
		var SolventFlag=SubGroupItem[42];
		var SIGroupStatus=SubGroupItem[43];
		if ((SIGroupStatus=="S")||(SIGroupStatus=="R")){
			GroupStatus="Stop";
		}
		if (OrderPrescNo=="") {
			OrderPresced=0
			if ((SheetItemStatus!="S")&&((SheetItemStatus!="R"))) BuildEnabledFlag=true;
		}else{
			OrderPresced=1
		}
		
		innerHTMLs=innerHTMLs+'<TR class="RowOdd" NOWRAP>';
		innerHTMLs=innerHTMLs+'<TD style="display:none;">';
	
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderItemRowidz"+j,OrderItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPriorRowidz"+j,OrderPriorRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCIMRowidz"+j,OrderARCIMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderTypez"+j,OrderType); 
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDoseUOMRowidz"+j,OrderDoseUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqRowidz"+j,OrderFreqRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderInstrRowidz"+j,OrderInstrRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz"+j,OrderFreqFactor);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqIntervalz"+j,OrderFreqInterval);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderConFacz"+j,OrderConFac);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPackUOMRowidz"+j,OrderPackUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtyz"+j,OrderBaseQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtySumz"+j,OrderBaseQtySum);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHFormz"+j,OrderPHForm);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHPrescTypez"+j,OrderPHPrescType);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDrugFormRowidz"+j,OrderDrugFormRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBillTypeRowidz"+j,OrderBillTypeRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderRecDepRowidz"+j,OrderRecDepRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxQtyz"+j,OrderMaxQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderAlertStockQtyz"+j,OrderAlertStockQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPoisonCodez"+j,OrderPoisonCode);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderHiddenParaz"+j,OrderHiddenPara);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemRowidz"+j,SheetItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemStatusz"+j,SheetItemStatus);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPrescedz"+j,OrderPresced);
		innerHTMLs=innerHTMLs+'</TD>';
		
		//innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 20px; HEIGHT: 22px">';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSeqNoz"+j,20,j);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderNamez"+j,230,OrderName);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderDoseQtyz"+j,50,OrderDoseQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderDoseUOMz"+j,50,OrderDoseUOM);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderFreqz"+j,70,OrderFreq);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderInstrz"+j,70,OrderInstr);
		if(SolventFlag=="Y"){
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled CHECKED type="checkbox"></input></TD>';
		}else{
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
		}
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPricez"+j,50,OrderPrice);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderDepProcNotez"+j,50,OrderDepProcNote);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackQtyz"+j,50,OrderPackQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackUOMz"+j,50,OrderPackUOM);
		//alert("OrderName="+OrderName+"		OrderPrescNo="+OrderPrescNo+"		SheetStatus="+SheetStatus+"		SheetItemStatus="+SheetItemStatus);
		if (OrderPrescNo==""){
			innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderBillTypez"+j,OrderBillType,100,"BillType_lookup()","");
			if((SheetStatus=="P")||(SheetStatus=="S")||(SheetStatus=="C")){
				if ((SheetItemStatus=="S")||(SheetItemStatus=="R")){
					innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled UNCHECKED type="checkbox"></input></TD>';			
				}else{
					innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" UNCHECKED type="checkbox"></input></TD>';			
				}	
			}else{
				innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED type="checkbox"></input></TD>';		
			}
 		}else{
 			innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderBillTypez"+j,100,OrderBillType);
 			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED disabled type="checkbox"></input></TD>';
 		}
 		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderMsgz"+j,150,OrderMsg);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSumz"+j,50,OrderSum);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderRecDepz"+j,50,OrderRecDep);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemStopDatez"+j,50,OrderItemStopDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemAddDatez"+j,50,OrderItemAddDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemBilledz"+j,50,OrderItemBilled);
		innerHTMLs=innerHTMLs+"</TR>";
	}
	innerHTMLs=innerHTMLs+"</TBODY>";
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>'; 
	
	innerHTMLs=innerHTMLs+'<TR><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList  id="'+GroupDId+'" Name="'+GroupDId+'" CELLSPACING=1 width="100%">';
	innerHTMLs=innerHTMLs+'<TR">'; 
	innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期</TD>';
	innerHTMLs=innerHTMLs+LookupCellReadonlyHtmlNew(GroupId+"MultiDate",ExecuteDate,630,"MultiDateClickhandler()","");
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+'<TR >'; 
	innerHTMLs=innerHTMLs+'<TD width=10%">组备注信息</TD><TD width=90%><input id="'+GroupId+'Remark" name="'+GroupId+'Remark" value="'+SubGroupRemark+'" input disabled Style="HEIGHT: 22px; WIDTH:800px""></input></TD>';
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>';
	
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"GroupStatus",GroupStatus);
	SheetGroupCell.innerHTML=innerHTMLs;
	if (VenousFillingFlag=="Y") DHCC_SetElementData(GroupId+"VenousFillingFlag",true);
	if (GroupStatus=="Stop") {
		var itemtbl=document.getElementById(GroupId);
		itemtbl.style.color="Red";
		itemtbl.style.backgroundColor="Red";
	}
	for (var j=1;j<=SubGroupStr.length;j++) {
		//SetNewColumnList(0,GroupId,j,0);
	}	
}

function ChangeGroupDetail(GroupStr){
	var objtbl=document.getElementById("tDHCPAAdmSheet_Edit");
	var rows=objtbl.rows.length;
	if (rows==2){
		var SheetGroupCell=GetCellObj("SheetGroup",1);
		if (SheetGroupCell.innerHTML!="&nbsp;"){
			AddNewRow(objtbl);
		}
	}else{
		AddNewRow(objtbl);
	}
	var Row=objtbl.rows.length-1;
	var SheetGroupCell=GetCellObj("SheetGroup",Row);
	var SheetGroup = document.createElement("DIV");
	SheetGroup.id="SheetGroup"+Row; 
	//SheetGroup.className = 'dhx_combo_list';
	
	//SheetGroup.style.width=parseInt(this.offsetWidth)+"px";
	var GroupId="tGroup"+Row;
	var GroupMId="tGroupM"+Row;
	var GroupDId="tGroupD"+Row;
	SheetGroup.style.width="1000px"
	SheetGroup.style.overflow="auto";      
	//SheetGroup.style.display = "block"; //block
	var innerHTMLs="<SPAN class='chartitemheading' id='GroupTitle'><IMG id='IMGZ0A1' src='../images/websys/minus.gif' border=0>&nbsp;<B>第"+Row+"组</B></SPAN>";
	innerHTMLs=innerHTMLs+'<TD >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+GroupId+'VenousFillingFlag" name="'+GroupId+'VenousFillingFlag" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox" onclick=\"VenousFillingFlagChangehandler()\">&nbsp;<B>建立静脉通道</B></input></TD>';
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupMId+'" Name="'+GroupMId+'" CELLSPACING=1 width="100%">';
	
	innerHTMLs=innerHTMLs+'<TR NOWRAP><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupId+'" Name="'+GroupId+'" CELLSPACING=1 width="100%" onclick="GroupItemSelectRow()">';
	innerHTMLs=innerHTMLs+'<THEAD>';
	innerHTMLs=innerHTMLs+"<TH id=1  NOWRAP>序号</TH>";
	innerHTMLs=innerHTMLs+"<TH id=2  NOWRAP>药品名称</TH>";
	innerHTMLs=innerHTMLs+"<TH id=3  NOWRAP>单次剂量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=4  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=5  NOWRAP>频次</TH>";
	innerHTMLs=innerHTMLs+"<TH id=6  NOWRAP>用法</TH>";
	innerHTMLs=innerHTMLs+"<TH id=7  NOWRAP>通道液</TH>";
	innerHTMLs=innerHTMLs+"<TH id=8  NOWRAP>单价</TH>";
	innerHTMLs=innerHTMLs+"<TH id=9  NOWRAP>备注</TH>";
	innerHTMLs=innerHTMLs+"<TH id=10  NOWRAP>取药数量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=11  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=12  NOWRAP>费别</TH>";
	innerHTMLs=innerHTMLs+"<TH id=13  NOWRAP>处方</TH>";
	innerHTMLs=innerHTMLs+"<TH id=14  NOWRAP>提示</TH>";
	innerHTMLs=innerHTMLs+"<TH id=15  NOWRAP>合计</TH>";
	innerHTMLs=innerHTMLs+"<TH id=16  NOWRAP>接收科室</TH>";
	innerHTMLs=innerHTMLs+"<TH id=17  NOWRAP>停止日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=18  NOWRAP>新增日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=19  NOWRAP>计费状态</TH>";
	innerHTMLs=innerHTMLs+"</THEAD>";
	innerHTMLs=innerHTMLs+"<TBODY>";
	var TempGroupStr=GroupStr.split(String.fromCharCode(3));
	var GroupStr=TempGroupStr[0];
	var GroupRemark=TempGroupStr[1];	//化疗单备注	
	var ExecuteDate=TempGroupStr[2];	//化疗日期
	var SubGroupRemark=TempGroupStr[3];	//组备注
	var LogStr=TempGroupStr[4];        //日志
	var SheetRemarkObj=document.getElementById('SheetRemark')
	if (SheetRemarkObj)SheetRemarkObj.value=GroupRemark
	var SheetLogObj=document.getElementById('SheetLog')
	if (SheetLogObj)SheetLogObj.value=LogStr
	var SubGroupStr=GroupStr.split(String.fromCharCode(1));
	var GroupStatus="";
	for (var j=1;j<=SubGroupStr.length;j++) {
		var k=j-1
		SubGroupItem=SubGroupStr[k].split("^");
		var OrderName=SubGroupItem[0];
		var OrderDoseQty=SubGroupItem[1];
		var OrderDoseUOM=SubGroupItem[2];
		var OrderFreq=SubGroupItem[3];
		var OrderInstr=SubGroupItem[4];
		var OrderPrice=SubGroupItem[5];
		var OrderDepProcNote=SubGroupItem[6];
		var OrderPackQty=SubGroupItem[7];
		var OrderPackUOM=SubGroupItem[8];
		var OrderBillType=SubGroupItem[9];
		var OrderMsg=SubGroupItem[10];
		var OrderSum=SubGroupItem[11];
		var OrderRecDep=SubGroupItem[12];
		;//Hidden Item
		var OrderItemRowid=SubGroupItem[13];    //
		var OrderPriorRowid=SubGroupItem[14];   //
		var OrderARCIMRowid=SubGroupItem[15];   //
		var OrderType=SubGroupItem[16];
		var OrderDoseUOMRowid=SubGroupItem[17]; //
		var OrderInstrRowid=SubGroupItem[18];   //
		var OrderFreqRowid=SubGroupItem[19];    //
		var OrderFreqFactor=SubGroupItem[20];
		var OrderFreqInterval=SubGroupItem[21];
		var OrderRecDepRowid=SubGroupItem[22];  //
		var OrderBillTypeRowid=SubGroupItem[23]  //
		var OrderPackUOMRowid=SubGroupItem[24]; //
		var OrderConFac=SubGroupItem[25];
		var OrderBaseQtySum=SubGroupItem[26];
		var OrderBaseQty=SubGroupItem[27]
		var OrderPHPrescType=SubGroupItem[28]
		var OrderPHForm=SubGroupItem[29];
		var OrderDrugFormRowid=SubGroupItem[30];
		var OrderMaxQty=SubGroupItem[31];
		var OrderAlertStockQty=SubGroupItem[32];
		var OrderPoisonCode=SubGroupItem[33];
		var OrderHiddenPara=SubGroupItem[34];
		var SheetItemRowid=SubGroupItem[35];
		var OrderPrescNo=SubGroupItem[36];
		var SheetItemStatus=SubGroupItem[37];
		var OrderItemStopDate=SubGroupItem[38];
		var OrderItemAddDate=SubGroupItem[39];
		var OrderItemBilled=SubGroupItem[40];
		var VenousFillingFlag=SubGroupItem[41];
		var SolventFlag=SubGroupItem[42];
		var SIGroupStatus=SubGroupItem[43];
		if ((SIGroupStatus=="S")||(SIGroupStatus=="R")){
			GroupStatus="Stop";
		}

		innerHTMLs=innerHTMLs+'<TR class="RowOdd" NOWRAP>';
		innerHTMLs=innerHTMLs+'<TD style="display:none;">';
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderItemRowidz"+j,OrderItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPriorRowidz"+j,OrderPriorRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCIMRowidz"+j,OrderARCIMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderTypez"+j,OrderType); 
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDoseUOMRowidz"+j,OrderDoseUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqRowidz"+j,OrderFreqRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderInstrRowidz"+j,OrderInstrRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurRowidz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz"+j,OrderFreqFactor);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqIntervalz"+j,OrderFreqInterval);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurFactorz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderConFacz"+j,OrderConFac);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPackUOMRowidz"+j,OrderPackUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtyz"+j,OrderBaseQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtySumz"+j,OrderBaseQtySum);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHFormz"+j,OrderPHForm);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHPrescTypez"+j,OrderPHPrescType);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDrugFormRowidz"+j,OrderDrugFormRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBillTypeRowidz"+j,OrderBillTypeRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderRecDepRowidz"+j,OrderRecDepRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCOSRowidz1","");
 		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxDurFactorz1","");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxQtyz"+j,OrderMaxQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderAlertStockQtyz"+j,OrderAlertStockQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPoisonCodez"+j,OrderPoisonCode);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderHiddenParaz"+j,OrderHiddenPara);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemRowidz"+j,SheetItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemStatusz"+j,SheetItemStatus);
		innerHTMLs=innerHTMLs+'</TD>';
		
		//innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 20px; HEIGHT: 22px">';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSeqNoz"+j,20,j);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderNamez"+j,230,OrderName);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderDoseQtyz"+j,50,OrderDoseQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderDoseUOMz"+j,50,OrderDoseUOM);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderFreqz"+j,70,OrderFreq);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderInstrz"+j,70,OrderInstr);
		if(SolventFlag=="Y"){
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled CHECKED type="checkbox"></input></TD>';
		}else{
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
		}
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPricez"+j,50,OrderPrice);
		innerHTMLs=innerHTMLs+InputCellHtml(GroupId+"OrderDepProcNotez"+j,50,OrderDepProcNote);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackQtyz"+j,50,OrderPackQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackUOMz"+j,50,OrderPackUOM);
		if (OrderPrescNo==""){
			innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderBillTypez"+j,OrderBillType,100,"BillType_lookup()","");
 			if ((SheetItemStatus=="S")||(SheetItemStatus=="R")){
				innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled UNCHECKED type="checkbox"></input></TD>';			
			}else{
				innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" UNCHECKED type="checkbox"></input></TD>';			
			}
 		}else{
 			innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderBillTypez"+j,100,OrderBillType);
 			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED disabled type="checkbox"></input></TD>';
 		}
 		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderMsgz"+j,150,OrderMsg);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSumz"+j,50,OrderSum);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderRecDepz"+j,50,OrderRecDep);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemStopDatez"+j,50,OrderItemStopDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemAddDatez"+j,50,OrderItemAddDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemBilledz"+j,50,OrderItemBilled);
		innerHTMLs=innerHTMLs+"</TR>";
	}
	innerHTMLs=innerHTMLs+"</TBODY>";
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>'; 
	
	innerHTMLs=innerHTMLs+'<TR><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList  id="'+GroupDId+'" Name="'+GroupDId+'" CELLSPACING=1 width="100%">';
	innerHTMLs=innerHTMLs+'<TR">'; 
	innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期</TD>';
	innerHTMLs=innerHTMLs+LookupCellReadonlyHtmlNew(GroupId+"MultiDate",ExecuteDate,630,"MultiDateClickhandler()","");
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+'<TR">'; 
	innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期调整为</TD>';
	if (GroupStatus!="Stop"){
		innerHTMLs=innerHTMLs+LookupCellReadonlyHtml(GroupId+"ChangeMultiDate",ExecuteDate,630,"ChangeMultiDateClickhandler()","");	
	}else{
		innerHTMLs=innerHTMLs+LookupCellReadonlyHtmlNew(GroupId+"ChangeMultiDate",ExecuteDate,630,"ChangeMultiDateClickhandler()","");	
	}
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+'<TR >'; 
	innerHTMLs=innerHTMLs+'<TD width=10%">组备注信息</TD><TD width=90%><input id="'+GroupId+'Remark" name="'+GroupId+'Remark" value="'+SubGroupRemark+'" input Style="HEIGHT: 22px; WIDTH:800px""></input></TD>';
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>';
	
	innerHTMLs=innerHTMLs+"</TABLE>";
	if (GroupStatus!="Stop"){
		innerHTMLs=innerHTMLs+"<SPAN class='chartitemheading'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"AddGroupItem' onclick='AddGroupItem("+Row+");'><IMG SRC='../images/websys/new.gif' BORDER=0>增加药品</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"DeleteGroupItem' onclick='DeleteGroupItem("+Row+");'><IMG SRC='../images/websys/delete.gif'BORDER=0>删除药品</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"StopGroupItem' onclick='StopGroupItem("+Row+");'><IMG SRC='../images/websys/sys_error.gif'BORDER=0>停止药品</A></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"CancelStopGroupItem' onclick='CancelStopGroupItem("+Row+");'><IMG SRC='../images/websys/update.gif'BORDER=0>撤销停止药品</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"StopGroup' onclick='StopGroup("+Row+");'><IMG SRC='../images/websys/sys_error.gif' BORDER=0><B>停止组</B></A></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"CancelStopGroup' onclick='CancelStopGroup("+Row+");' disabled><IMG SRC='../images/websys/update.gif' BORDER=0><B>撤销停止组</B></A></SPAN>";         
	}
	innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"GroupStatus",GroupStatus);
	SheetGroupCell.innerHTML=innerHTMLs;
	if (VenousFillingFlag=="Y") {
		DHCC_SetElementData(GroupId+"VenousFillingFlag",true);
		//ChangeSolventFlag(GroupId);
	}else{
		DHCC_SetElementData(GroupId+"VenousFillingFlag",false);
	}
	if (GroupStatus=="Stop") {
		var itemtbl=document.getElementById(GroupId);
		itemtbl.style.color="Red";
		itemtbl.style.backgroundColor="Red";
	}
}

///Creator:				徐鹏
///CreatDate:			2009-03-11
///Description:		停止一组药品.实现如下功能:置药品状态的状态为"停止";置组的状态为"停止";
///								用颜色标示出停止的组;设置按钮可用状态
///Input:					停止组的组号
function StopGroup(Row) {
	try {
		var tGroupId="tGroup"+Row;
		var StopGroupObj=document.getElementById(tGroupId+"StopGroup");
		if (StopGroupObj.disabled==true){
			return;
		}
		var itemtbl=document.getElementById(tGroupId);
		GroupStatus=DHCC_GetElementData(tGroupId+"GroupStatus");
		itemtbl.style.color="Red";
		itemtbl.style.backgroundColor="Red";
		DHCC_SetElementData(tGroupId+"GroupStatus","To Stop");
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",j);
			var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",j);
			if ((OrderARCIMRowid!="")){
				if (OrderItemRowid!=""){
					SetColumnData(tGroupId,"SheetItemStatus",j,"To Stop")
				}else{
					itemtbl.deleteRow(j);
					j=j-1;
				}
			}
		}
		ItemButtonDisabled(tGroupId,true);
		var StopGroupObj=document.getElementById(tGroupId+"StopGroup");
		if (StopGroupObj){
			StopGroupObj.disabled=true;	
		}
		var CancelStopGroupObj=document.getElementById(tGroupId+"CancelStopGroup");
		if (CancelStopGroupObj){
			CancelStopGroupObj.disabled=false;	
		}
	} catch(e) {};
}

///Creator:				徐鹏
///CreatDate:			2009-03-11
///Description:		停止一组药品.实现如下功能:置药品状态的状态为"正常";置组的状态为"正常";
///								恢复组的颜色;设置按钮可用状态
///Input:					停止组的组号
function CancelStopGroup(Row) {
	// 撤销停止一组药品
	try {
		var tGroupId="tGroup"+Row;
		var CancelStopGroupObj=document.getElementById(tGroupId+"CancelStopGroup");
		if (CancelStopGroupObj.disabled==true){
			return;
		}
		var itemtbl=document.getElementById(tGroupId);
		itemtbl.style.color="";
		itemtbl.style.backgroundColor="";
		DHCC_SetElementData(tGroupId+"GroupStatus","Normal")
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",j);
			var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",j);
			if ((OrderItemRowid!="")&&(OrderARCIMRowid!="")){
				SetColumnData(tGroupId,"SheetItemStatus",j,"")
				SetRowColor(tGroupId,j,"");
			}	
		}
		ItemButtonDisabled(tGroupId,false);
		var CancelStopGroupObj=document.getElementById(tGroupId+"CancelStopGroup");
		if (CancelStopGroupObj){
			CancelStopGroupObj.disabled=true;	
		}
		var StopGroupObj=document.getElementById(tGroupId+"StopGroup");
		if (StopGroupObj){
			StopGroupObj.disabled=false;	
		}
	} catch(e) {};
}

///Creator:				徐鹏
///CreatDate:			2009-03-11
///Description:		对于操作药品的按钮,设置是否可用的状态
///Input:					tGroupId:操作组的组号;tGroupId:设置为可用与否,Boolean;
function ItemButtonDisabled(tGroupId,DisabledFlag) {
	//对于操作药品的按钮,设置是否可用的状态
	var AddGroupItemObj=document.getElementById(tGroupId+"AddGroupItem");
	if (AddGroupItemObj){
		AddGroupItemObj.disabled=DisabledFlag;	
	}
	var DeleteGroupItemObj=document.getElementById(tGroupId+"DeleteGroupItem");
	if (DeleteGroupItemObj){
		DeleteGroupItemObj.disabled=DisabledFlag;	
	}
	var StopGroupItemObj=document.getElementById(tGroupId+"StopGroupItem");
	if (StopGroupItemObj){
		StopGroupItemObj.disabled=DisabledFlag;	
	}
	var CancelStopGroupItemObj=document.getElementById(tGroupId+"CancelStopGroupItem");
	if (CancelStopGroupItemObj){
		CancelStopGroupItemObj.disabled=DisabledFlag;	
	}
}

function ChangeSolventFlag(tGroupId){
	var itemtbl=document.getElementById(tGroupId);
	var itemrows=itemtbl.rows.length;
	for (var j=1; j<itemrows; j++){
		var Row=GetRow(tGroupId,j);
		var CellObj=document.getElementById(tGroupId+"SolventFlagz"+Row);
		if (CellObj){	
			CellObj.disabled=false;	
		}
	}
}

function VenousFillingFlagChangehandler(e){
	var obj=websys_getSrcElement(e);
	SubObjId=obj.id.split("VenousFillingFlag");
	tGroupId=SubObjId[0];
	var VenousFillingFlag=DHCC_GetElementData(tGroupId+"VenousFillingFlag");
	var itemtbl=document.getElementById(tGroupId);
	var itemrows=itemtbl.rows.length;
	for (var j=1; j<itemrows; j++){
		var Row=GetRow(tGroupId,j);
		var CellObj=document.getElementById(tGroupId+"SolventFlagz"+Row);
		if (CellObj){	
			if (VenousFillingFlag){
				CellObj.disabled=false;	
			}else{
				CellObj.disabled=true;	
				CellObj.checked=false;	
			}
		}
	}
}

function AddGroupDetail(GroupStr){
	var objtbl=document.getElementById("tDHCPAAdmSheet_Edit");
	var rows=objtbl.rows.length;
	if (rows==2){
		var SheetGroupCell=GetCellObj("SheetGroup",1);
		if (SheetGroupCell.innerHTML!="&nbsp;"){
			AddNewRow(objtbl);
		}
	}else{
		AddNewRow(objtbl);
	}
	var Row=objtbl.rows.length-1;
	var SheetGroupCell=GetCellObj("SheetGroup",Row);
	var SheetGroup = document.createElement("DIV");
	SheetGroup.id="SheetGroup"+Row; 
	
	//SheetGroup.className = 'dhx_combo_list';
	//SheetGroup.style.width=parseInt(this.offsetWidth)+"px";
	var GroupId="tGroup"+Row;
	var GroupMId="tGroupM"+Row;
	var GroupDId="tGroupD"+Row;
	SheetGroup.style.width="1000px"
	SheetGroup.style.overflow="auto";      
	//SheetGroup.style.display = "block"; //block
	var innerHTMLs="<SPAN class='chartitemheading' id='GroupTitle'><IMG id='IMGZ0A1' src='../images/websys/minus.gif' border=0>&nbsp;<B>第"+Row+"组</B></SPAN>";
	innerHTMLs=innerHTMLs+'<TD >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+GroupId+'VenousFillingFlag" name="'+GroupId+'VenousFillingFlag" Style="WIDTH: 30px; HEIGHT: 22px" type="checkbox" onclick=\"VenousFillingFlagChangehandler()\">&nbsp;<B>建立静脉通道</B></input></TD>';
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupMId+'" Name="'+GroupMId+'" CELLSPACING=1 width="100%">';
	
	innerHTMLs=innerHTMLs+'<TR NOWRAP><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupId+'" Name="'+GroupId+'" CELLSPACING=1 width="100%" onclick="GroupItemSelectRow()">';
	innerHTMLs=innerHTMLs+'<THEAD>';
	innerHTMLs=innerHTMLs+"<TH id=1  NOWRAP>序号</TH>";
	innerHTMLs=innerHTMLs+"<TH id=2  NOWRAP>药品名称</TH>";
	innerHTMLs=innerHTMLs+"<TH id=3  NOWRAP>单次剂量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=4  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=5  NOWRAP>频次</TH>";
	innerHTMLs=innerHTMLs+"<TH id=6  NOWRAP>用法</TH>";
	innerHTMLs=innerHTMLs+"<TH id=7  NOWRAP>通道液</TH>";
	innerHTMLs=innerHTMLs+"<TH id=8  NOWRAP>单价</TH>";
	innerHTMLs=innerHTMLs+"<TH id=9  NOWRAP>备注</TH>";
	innerHTMLs=innerHTMLs+"<TH id=10  NOWRAP>取药数量</TH>";
	innerHTMLs=innerHTMLs+"<TH id=11  NOWRAP>单位</TH>";
	innerHTMLs=innerHTMLs+"<TH id=12  NOWRAP>费别</TH>";
	innerHTMLs=innerHTMLs+"<TH id=13  NOWRAP>处方</TH>";
	innerHTMLs=innerHTMLs+"<TH id=14  NOWRAP>提示</TH>";
	innerHTMLs=innerHTMLs+"<TH id=15  NOWRAP>合计</TH>";
	innerHTMLs=innerHTMLs+"<TH id=16  NOWRAP>接收科室</TH>";
	innerHTMLs=innerHTMLs+"<TH id=17  NOWRAP>停止日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=18  NOWRAP>新增日期</TH>";
	innerHTMLs=innerHTMLs+"<TH id=19  NOWRAP>计费状态</TH>";
	innerHTMLs=innerHTMLs+"</THEAD>";
	innerHTMLs=innerHTMLs+"<TBODY>";
	
	var TempGroupStr=GroupStr.split(String.fromCharCode(3));
	var GroupStr=TempGroupStr[0];
	var GroupRemark=TempGroupStr[1];	//化疗单备注	
	var ExecuteDate=TempGroupStr[2];	//化疗日期
	var SubGroupRemark=TempGroupStr[3];	//组备注
	var LogStr=TempGroupStr[4];        //日志
	var SheetRemarkObj=document.getElementById('SheetRemark')
	if (SheetRemarkObj)SheetRemarkObj.value=GroupRemark
	var SheetLogObj=document.getElementById('SheetLog')
	if (SheetLogObj)SheetLogObj.value=LogStr
	var SubGroupStr=GroupStr.split(String.fromCharCode(1));
	
	for (var j=1;j<=SubGroupStr.length;j++) {
		var k=j-1
		SubGroupItem=SubGroupStr[k].split("^");
		var OrderName=SubGroupItem[0];
		var OrderDoseQty=SubGroupItem[1];
		var OrderDoseUOM=SubGroupItem[2];
		var OrderFreq=SubGroupItem[3];
		var OrderInstr=SubGroupItem[4];
		var OrderPrice=SubGroupItem[5];
		var OrderDepProcNote=SubGroupItem[6];
		var OrderPackQty=SubGroupItem[7];
		var OrderPackUOM=SubGroupItem[8];
		var OrderBillType=SubGroupItem[9];
		var OrderMsg=SubGroupItem[10];
		var OrderSum=SubGroupItem[11];
		var OrderRecDep=SubGroupItem[12];
		;//Hidden Item
		var OrderItemRowid=SubGroupItem[13];    //
		var OrderPriorRowid=SubGroupItem[14];   //
		//var OrderPriorRowid="";   //
		var OrderARCIMRowid=SubGroupItem[15];   //
		var OrderType=SubGroupItem[16];
		var OrderDoseUOMRowid=SubGroupItem[17]; //
		var OrderInstrRowid=SubGroupItem[18];   //
		var OrderFreqRowid=SubGroupItem[19];    //
		var OrderFreqFactor=SubGroupItem[20];
		var OrderFreqInterval=SubGroupItem[21]; 
		var OrderRecDepRowid=SubGroupItem[22];  //
		var OrderBillTypeRowid=SubGroupItem[23] // 
		var OrderPackUOMRowid=SubGroupItem[24]; //
		var OrderConFac=SubGroupItem[25];				//*
		var OrderBaseQtySum=SubGroupItem[26];
		var OrderBaseQty=SubGroupItem[27]				
		var OrderPHPrescType=SubGroupItem[28]		
		var OrderPHForm=SubGroupItem[29];
		var OrderDrugFormRowid=SubGroupItem[30];
		var OrderMaxQty=SubGroupItem[31];				//*
		var OrderAlertStockQty=SubGroupItem[32];
		var OrderPoisonCode=SubGroupItem[33];		//*
		var OrderHiddenPara=SubGroupItem[34];
		var SheetItemRowid=SubGroupItem[35];
		var OrderPrescNo=SubGroupItem[36];
		var SheetItemStatus=SubGroupItem[37];
		var OrderItemStopDate=SubGroupItem[38];
		var OrderItemAddDate=SubGroupItem[39];
		var OrderItemBilled=SubGroupItem[40];
		var VenousFillingFlag=SubGroupItem[41];
		var SolventFlag=SubGroupItem[42];
		var SIGroupStatus=SubGroupItem[43];
		if ((SIGroupStatus=="S")||(SIGroupStatus=="R")){
			GroupStatus="Stop";
		}
		if (OrderPrescNo=="") {
			OrderPresced=0
			if ((SheetItemStatus!="S")&&((SheetItemStatus!="R"))) BuildEnabledFlag=true;
		}else{
			OrderPresced=1
		}
		if (VenousFillingFlag="Y") DHCC_SetElementData("VenousFillingFlag",true);
		innerHTMLs=innerHTMLs+'<TR class="RowOdd" NOWRAP>';
		innerHTMLs=innerHTMLs+'<TD style="display:none;">';
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderItemRowidz"+j,OrderItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPriorRowidz"+j,OrderPriorRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCIMRowidz"+j,OrderARCIMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderTypez"+j,OrderType); 
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDoseUOMRowidz"+j,OrderDoseUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqRowidz"+j,OrderFreqRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderInstrRowidz"+j,OrderInstrRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurRowidz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz"+j,OrderFreqFactor);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqIntervalz"+j,OrderFreqInterval);
 		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurFactorz"+j,"");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderConFacz"+j,OrderConFac);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPackUOMRowidz"+j,OrderPackUOMRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtyz"+j,OrderBaseQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtySumz"+j,OrderBaseQtySum);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHFormz"+j,OrderPHForm);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHPrescTypez"+j,OrderPHPrescType);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDrugFormRowidz"+j,OrderDrugFormRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBillTypeRowidz"+j,OrderBillTypeRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderRecDepRowidz"+j,OrderRecDepRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCOSRowidz1","");
 		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxDurFactorz1","");
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxQtyz"+j,OrderMaxQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderAlertStockQtyz"+j,OrderAlertStockQty);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPoisonCodez"+j,OrderPoisonCode);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderHiddenParaz"+j,OrderHiddenPara);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemRowidz"+j,SheetItemRowid);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"SheetItemStatusz"+j,SheetItemStatus);
		innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPrescedz"+j,OrderPresced);
		innerHTMLs=innerHTMLs+'</TD>';

		//innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 20px; HEIGHT: 22px">';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSeqNoz"+j,20,j);
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderNamez"+j,OrderName,230,"xItem_lookuphandler()","");
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><input id="'+GroupId+'OrderDoseQtyz'+j+'" name="'+GroupId+'OrderDoseQtyz'+j+'" value="'+OrderDoseQty+'" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderDoseQtychangehandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">&nbsp;</input></TD>';
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderDoseUOMz'+j+'" name="'+GroupId+'OrderDoseUOMz'+j+'" value="'+OrderDoseUOM+'" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderDoseUOMchangehandler()\">&nbsp;</select></TD>';
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderFreqz"+j,OrderFreq,70,"PHCFRDesc_lookuphandler()","FrequencyChangeHandler()");
 		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderInstrz"+j,OrderInstr,70,"PHCINDesc_lookuphandler()","InstrChangeHandler()");
 		if(SolventFlag=="Y"){
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled CHECKED type="checkbox"></input></TD>';
		}else{
			innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
		}
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPricez"+j,50,OrderPrice);
		innerHTMLs=innerHTMLs+InputCellHtml(GroupId+"OrderDepProcNotez"+j,50,OrderDepProcNote);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackQtyz"+j,50,OrderPackQty);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderPackUOMz"+j,50,OrderPackUOM);
		innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderBillTypez"+j,OrderBillType,100,"BillType_lookup()","");
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz'+j+'" name="'+GroupId+'OrderPrescz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED type="checkbox"></input></TD>';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderMsgz"+j,150,OrderMsg);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderSumz"+j,50,OrderSum);
		innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderRecDepz'+j+'" name="'+GroupId+'OrderRecDepz'+j+'" Style="WIDTH: 150px; HEIGHT: 22px" onchange=\"OrderRecDepchangehandler()\">&nbsp;</select></TD>';
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemStopDatez"+j,50,OrderItemStopDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemAddDatez"+j,50,OrderItemAddDate);
		innerHTMLs=innerHTMLs+LabelCellHtml(GroupId+"OrderItemBilledz"+j,50,OrderItemBilled);
		innerHTMLs=innerHTMLs+"</TR>";
	}
	innerHTMLs=innerHTMLs+"</TBODY>";
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>'; 
	
	innerHTMLs=innerHTMLs+'<TR><TD>'; 
	innerHTMLs=innerHTMLs+'<TABLE class=tblList  id="'+GroupDId+'" Name="'+GroupDId+'" CELLSPACING=1 width="100%">';
	innerHTMLs=innerHTMLs+'<TR">'; 
	innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期</TD>';
	innerHTMLs=innerHTMLs+LookupCellReadonlyHtml(GroupId+"MultiDate",ExecuteDate,630,"MultiDateClickhandler()","");
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+'<TR >'; 
	innerHTMLs=innerHTMLs+'<TD width=10%">组备注信息</TD><TD width=90%><input id="'+GroupId+'Remark" name="'+GroupId+'Remark" value="'+SubGroupRemark+'" Style="HEIGHT: 22px; WIDTH:800px""></input></TD>';
	innerHTMLs=innerHTMLs+'</TR>'; 
	innerHTMLs=innerHTMLs+"</TABLE>";
	innerHTMLs=innerHTMLs+'</TD></TR>';
	
	innerHTMLs=innerHTMLs+"</TABLE>";
  innerHTMLs=innerHTMLs+"<SPAN class='chartitemheading'>&nbsp;<A HREF='#' id='"+GroupId+"AddGroupItem' onclick='AddGroupItem("+Row+");'><IMG SRC='../images/websys/new.gif' BORDER=0>增加药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"DeleteGroupItem' onclick='DeleteGroupItem("+Row+");'><IMG SRC='../images/websys/delete.gif'BORDER=0>删除药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='ShowRemark("+Row+");'><IMG SRC='../images/websys/new.gif'BORDER=0>录入备注</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroupItem();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroupItem();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='DeleteGroup' onclick='DeleteGroup();'><IMG SRC='../images/websys/delete.gif' BORDER=0><B>删除组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroup();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroup();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移组</B></A></SPAN>";
  innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"GroupStatus",GroupStatus);
	SheetGroupCell.innerHTML=innerHTMLs;
	if (VenousFillingFlag=="Y") {
		DHCC_SetElementData(GroupId+"VenousFillingFlag",true);
		ChangeSolventFlag(GroupId);
	}else{
		DHCC_SetElementData(GroupId+"VenousFillingFlag",false);
	}
	
	for (var j=1;j<=SubGroupStr.length;j++){
		SetNewColumnList(1,GroupId,j,0)
	}
}

function LabelCellHtml(cellid,cellwidth,txt){
	var inputwidth=cellwidth;
	var str='<TD  STYLE="WIDTH: '+cellwidth+'px; HEIGHT: 22px">';
	var str=str+'<label id=\"'+cellid+'\" name=\"'+cellid+'\" Style="WIDTH:'+inputwidth+'px; HEIGHT: 22px">'+txt+'</label>';
	var str=str+'</TD>';
	return str;
}
function GetCellObj(ColumnName,Row){
	var cellname=ColumnName+"z"+Row
	var obj=document.getElementById(cellname);
	return obj
}

function AddNewRow(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""};
		}
	}

	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="Gray";} else {objnewrow.className="RowOdd";}}
}

function CanAddGroup(){
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;

	i=rows-1
	var GroupNo=GetGroupRow(objtbl,i);
	var grouptbl=GetCellObj('SheetGroup',GroupNo);
	var f=websys_getChildElements(grouptbl);
	for (var j=0;j<f.length;j++) {
		if (f[j].tagName=="TABLE") {
			if (f[j].id.substring(0,7)=="tGroupM"){
				var SubObjId=f[j].id.split("tGroupM");
				var GroupRow=SubObjId[1];
			}
		}
	}
	
	var tGroupId="tGroup"+GroupRow;		
	var Row=GetRow(tGroupId,1);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
	if (OrderARCIMRowid=="") {
		return false;
	}
	return true;	
}

function AddClickHandler(){
	var Ret=CanAddGroup();
	if (Ret==false) return;
	var objtbl=document.getElementById("tDHCPAAdmSheet_Edit");
	var rows=objtbl.rows.length;
	if (rows==2){
		AddNewRow(objtbl);
	}else{
		AddNewRow(objtbl);
	}
	var Row=objtbl.rows.length-1;
	DHCC_SetColumnData("GroupNo",Row,Row);
	AddGroupDIVToCell(Row);
	websys_setfocus("tGroup"+Row+"OrderNamez1");
}

function GetGroupRowIndex(e){
	var obj=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);

	var TRSrc=websys_getParentElement(TRSrc);

	var TRSrc=websys_getParentElement(TRSrc);
	var TRSrc=websys_getParentElement(TRSrc);	
	//alert(TRSrc.innerHTML);
	return TRSrc.rowIndex;
}

function GetGroupRow(objtbl,RowIndex){
	var RowObj=objtbl.rows[RowIndex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			if (arrId[0]=="SheetGroup") var Row=arrId[arrId.length-1];
		}
	}	
	return Row;
}

function ChangeInnerHtml(SelRowIndex){
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	for (var i=SelRowIndex; i<rows; i++){
		var Row=GetGroupRow(objtbl,i);		
		var GroupCell=GetCellObj("SheetGroup",Row);
		var GroupCellHTML=GroupCell.innerHTML;
		
		var GroupId="tGroup"+Row;
		var GroupMId="tGroupM"+Row;
		var GroupDId="tGroupD"+Row;
		var GroupNoDesc="第"+Row+"组";
		var GroupIdExp=new RegExp(GroupId,"g"); 
		var GroupMIdExp=new RegExp(GroupMId,"g"); 
		var GroupDIdExp=new RegExp(GroupDId,"g");
		var NewRowIndex=Row-1;
		var NewGroupId="tGroup"+NewRowIndex;
		var NewGroupMId="tGroupM"+NewRowIndex;
		var NewGroupDId="tGroupD"+NewRowIndex;
		var NewGroupNoDesc="第"+NewRowIndex+"组";
		
		var GroupCellHTML=GroupCellHTML.replace(GroupIdExp,NewGroupId);
		var GroupCellHTML=GroupCellHTML.replace(GroupMIdExp,NewGroupMId);
		var GroupCellHTML=GroupCellHTML.replace(GroupDIdExp,NewGroupDId);
		var GroupCellHTML=GroupCellHTML.replace("AddGroupItem("+Row+")","AddGroupItem("+NewRowIndex+")");
		var GroupCellHTML=GroupCellHTML.replace("DeleteGroupItem("+Row+")","DeleteGroupItem("+NewRowIndex+")");
		var GroupCellHTML=GroupCellHTML.replace("ShowRemark("+Row+")","ShowRemark("+NewRowIndex+")");
		var GroupCellHTML=GroupCellHTML.replace(GroupNoDesc,NewGroupNoDesc);
		GroupCell.innerHTML=GroupCellHTML;
		GroupCell.id=GroupCell.id.substring(0,11)+NewRowIndex;
	}
}

function DeleteGroup(e) {
	try {
		var SelRowIndex=GetGroupRowIndex(e);
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		if (rows>2){
			objtbl.deleteRow(SelRowIndex);
			ChangeInnerHtml(SelRowIndex);
		}else{
			var Row=GetGroupRow(objtbl,1);
			websys_setfocus("tGroup"+Row+"OrderNamez1");
		}
		
	  //add by zhouzq 2005.07.07 for recalculate sum
	  SetScreenSum()
    return false;
	} catch(e) {};
}

function UpGroup(e) {
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	var SelRowIndex=GetGroupRowIndex(e);
	if (SelRowIndex<2) return;
	
	var tGroupId="tGroup"+SelRowIndex;
	var Row=GetRow(tGroupId,1);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
	if (OrderARCIMRowid=="")  return;

	var Row=GetGroupRow(objtbl,SelRowIndex);
	var FromSheetGroupCell=GetCellObj("SheetGroup",Row);
	var FromSheetGroupCellHTML=FromSheetGroupCell.innerHTML;
	var Row1=GetGroupRow(objtbl,SelRowIndex-1);
	var ToSheetGroupCell=GetCellObj("SheetGroup",Row1);
	var ToSheetGroupCellHTML=ToSheetGroupCell.innerHTML;
	
	// Exchange Group by exchanging their HTML;Before exchanging,modify the "id" in the HTML
	var GroupId="tGroup"+SelRowIndex;
	var GroupMId="tGroupM"+SelRowIndex;
	var GroupDId="tGroupD"+SelRowIndex;
	var GroupIdExp=new RegExp(GroupId,"g"); 
	var GroupMIdExp=new RegExp(GroupMId,"g"); 
	var GroupDIdExp=new RegExp(GroupDId,"g");
	 
	var NewRowIndex=SelRowIndex-1;
	var NewGroupId="tGroup"+NewRowIndex;
	var NewGroupMId="tGroupM"+NewRowIndex;
	var NewGroupDId="tGroupD"+NewRowIndex;
	var NewGroupIdExp=new RegExp(NewGroupId,"g"); 
	var NewGroupMIdExp=new RegExp(NewGroupMId,"g");
	var NewGroupDIdExp=new RegExp(NewGroupDId,"g");
	
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupIdExp,NewGroupId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupMIdExp,NewGroupMId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupDIdExp,NewGroupDId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("AddGroupItem("+SelRowIndex+")","AddGroupItem("+NewRowIndex+")");
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("DeleteGroupItem("+SelRowIndex+")","DeleteGroupItem("+NewRowIndex+")");
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("ShowRemark("+SelRowIndex+")","ShowRemark("+NewRowIndex+")");
	
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupIdExp,GroupId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupMIdExp,GroupMId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupDIdExp,GroupDId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("AddGroupItem("+NewRowIndex+")","AddGroupItem("+SelRowIndex+")");
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("DeleteGroupItem("+NewRowIndex+")","DeleteGroupItem("+SelRowIndex+")");
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("ShowRemark("+NewRowIndex+")","ShowRemark("+SelRowIndex+")");

	FromSheetGroupCell.innerHTML=ToSheetGroupCellHTML;
	ToSheetGroupCell.innerHTML=FromSheetGroupCellHTML;															 
	
}

function DownGroup(e) {
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	var SelRowIndex=GetGroupRowIndex(e);
	if (SelRowIndex>rows-2) return;
	
	var LowerRow=SelRowIndex+1
	var tGroupId="tGroup"+LowerRow;
	var Row=GetRow(tGroupId,1);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
	if (OrderARCIMRowid=="")  return;
	
	var Row=GetGroupRow(objtbl,SelRowIndex);
	var FromSheetGroupCell=GetCellObj("SheetGroup",Row);
	var FromSheetGroupCellHTML=FromSheetGroupCell.innerHTML;
	var Row1=GetGroupRow(objtbl,SelRowIndex+1);
	var ToSheetGroupCell=GetCellObj("SheetGroup",Row1);
	var ToSheetGroupCellHTML=ToSheetGroupCell.innerHTML;
	
	// Exchange Group by exchanging their HTML;Before exchanging,modify the "id" in the HTML
	var GroupId="tGroup"+SelRowIndex;
	var GroupMId="tGroupM"+SelRowIndex;
	var GroupDId="tGroupD"+SelRowIndex;
	var GroupIdExp=new RegExp(GroupId,"g"); 
	var GroupMIdExp=new RegExp(GroupMId,"g"); 
	var GroupDIdExp=new RegExp(GroupDId,"g"); 
	
	var NewRowIndex=SelRowIndex+1;
	var NewGroupId="tGroup"+NewRowIndex;
	var NewGroupMId="tGroupM"+NewRowIndex;
	var NewGroupDId="tGroupD"+NewRowIndex;
	var NewGroupIdExp=new RegExp(NewGroupId,"g"); 
	var NewGroupMIdExp=new RegExp(NewGroupMId,"g");
	var NewGroupDIdExp=new RegExp(NewGroupDId,"g");
	
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupIdExp,NewGroupId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupMIdExp,NewGroupMId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace(GroupDIdExp,NewGroupDId);
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("AddGroupItem("+SelRowIndex+")","AddGroupItem("+NewRowIndex+")");
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("DeleteGroupItem("+SelRowIndex+")","DeleteGroupItem("+NewRowIndex+")");
	var FromSheetGroupCellHTML=FromSheetGroupCellHTML.replace("ShowRemark("+SelRowIndex+")","ShowRemark("+NewRowIndex+")");

	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupIdExp,GroupId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupMIdExp,GroupMId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace(NewGroupDIdExp,GroupDId);
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("AddGroupItem("+NewRowIndex+")","AddGroupItem("+SelRowIndex+")");
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("DeleteGroupItem("+NewRowIndex+")","DeleteGroupItem("+SelRowIndex+")");
	var ToSheetGroupCellHTML=ToSheetGroupCellHTML.replace("ShowRemark("+NewRowIndex+")","ShowRemark("+SelRowIndex+")");

	FromSheetGroupCell.innerHTML=ToSheetGroupCellHTML;
	ToSheetGroupCell.innerHTML=FromSheetGroupCellHTML;

}

function AddGroupDIVToCell(Row){
 var SheetGroupCell=GetCellObj("SheetGroup",Row);
 var SheetGroup = document.createElement("DIV");
 SheetGroup.id="SheetGroup"+Row; 
 //SheetGroup.className = 'dhx_combo_list';
 //SheetGroup.style.width=parseInt(this.offsetWidth)+"px";
 
 var GroupId="tGroup"+Row;
 var GroupMId="tGroupM"+Row;
 var GroupDId="tGroupD"+Row;

 SheetGroup.style.width="1000px"
 SheetGroup.style.overflow="auto";      
 //SheetGroup.style.display = "block"; //block
 var innerHTMLs="<SPAN class='chartitemheading' id='GroupTitle'><IMG id='IMGZ0A1' src='../images/websys/minus.gif' border=0>&nbsp;<B>第"+Row+"组</B></SPAN>";
 innerHTMLs=innerHTMLs+'<TD >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="'+GroupId+'VenousFillingFlag" name="'+GroupId+'VenousFillingFlag" Style="WIDTH: 30px; HEIGHT: 22px" type="checkbox" onclick=\"VenousFillingFlagChangehandler()\">&nbsp;<B>建立静脉通道</B></input></TD>';
 innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupMId+'" Name="'+GroupMId+'" CELLSPACING=1 width="100%">';

 innerHTMLs=innerHTMLs+'<TR NOWRAP><TD>'; 
 innerHTMLs=innerHTMLs+'<TABLE class=tblList id="'+GroupId+'" Name="'+GroupId+'" CELLSPACING=1 width="100%" onclick="GroupItemSelectRow()">';
 innerHTMLs=innerHTMLs+'<THEAD>';
 innerHTMLs=innerHTMLs+"<TH id=1  NOWRAP>序号</TH>";
 innerHTMLs=innerHTMLs+"<TH id=2  NOWRAP>药品名称</TH>";
 innerHTMLs=innerHTMLs+"<TH id=3  NOWRAP>单次剂量</TH>";
 innerHTMLs=innerHTMLs+"<TH id=4  NOWRAP>单位</TH>";
 innerHTMLs=innerHTMLs+"<TH id=5  NOWRAP>频次</TH>";
 innerHTMLs=innerHTMLs+"<TH id=6  NOWRAP>用法</TH>";
 innerHTMLs=innerHTMLs+"<TH id=7  NOWRAP>通道液</TH>";
 innerHTMLs=innerHTMLs+"<TH id=8  NOWRAP>单价</TH>";
 innerHTMLs=innerHTMLs+"<TH id=9  NOWRAP>备注</TH>";
 innerHTMLs=innerHTMLs+"<TH id=10  NOWRAP>取药数量</TH>";
 innerHTMLs=innerHTMLs+"<TH id=11  NOWRAP>单位</TH>";
 innerHTMLs=innerHTMLs+"<TH id=12  NOWRAP>费别</TH>";
 innerHTMLs=innerHTMLs+"<TH id=13  NOWRAP>处方</TH>";
 innerHTMLs=innerHTMLs+"<TH id=14  NOWRAP>提示</TH>";
 innerHTMLs=innerHTMLs+"<TH id=15  NOWRAP>合计</TH>";
 innerHTMLs=innerHTMLs+"<TH id=16  NOWRAP>接收科室</TH>";
 innerHTMLs=innerHTMLs+"</THEAD>";
 innerHTMLs=innerHTMLs+"<TBODY>";
 innerHTMLs=innerHTMLs+'<TR class="RowOdd" NOWRAP>';
 innerHTMLs=innerHTMLs+'<TD style="display:none;">';

 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderItemRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPriorRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCIMRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderTypez1",""); 
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDoseUOMRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderInstrRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqIntervalz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderFreqFactorz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDurFactorz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderConFacz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPackUOMRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtyz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBaseQtySumz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHFormz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPHPrescTypez1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderDrugFormRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderBillTypeRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderRecDepRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderARCOSRowidz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxDurFactorz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderMaxQtyz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderAlertStockQtyz1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderPoisonCodez1","");
 innerHTMLs=innerHTMLs+HiddenTableCellHtml(GroupId+"OrderHiddenParaz1","");
 innerHTMLs=innerHTMLs+'</TD>';
 
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 20px; HEIGHT: 22px"><label id="'+GroupId+'OrderSeqNoz1" name="'+GroupId+'OrderSeqNo" Style="WIDTH: 20px; HEIGHT: 22px">1</label></TD>';
 innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderNamez1","",230,"xItem_lookuphandler()","");
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><input id="'+GroupId+'OrderDoseQtyz1" name="'+GroupId+'OrderDoseQtyz1" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderDoseQtychangehandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">&nbsp;</input></TD>';
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderDoseUOMz1" name="'+GroupId+'OrderDoseUOMz1" Style="WIDTH: 50px; HEIGHT: 22px" value=\"\" onchange=\"OrderDoseUOMchangehandler()\">&nbsp;</select></TD>';
 innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderFreqz1","",70,"PHCFRDesc_lookuphandler()","FrequencyChangeHandler()");
 innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderInstrz1","",70,"PHCINDesc_lookuphandler()","InstrChangeHandler()");
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz1" name="'+GroupId+'SolventFlagz1" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><label id="'+GroupId+'OrderPricez1" name="'+GroupId+'OrderPricez1" Style="WIDTH: 50px; HEIGHT: 22px">&nbsp;</lable></TD>';
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><input id="'+GroupId+'OrderDepProcNotez1" name="'+GroupId+'OrderDepProcNotez1" Style="WIDTH: 50px; HEIGHT: 22px">&nbsp;</input></TD>';
 if (ChangeFlag==1){
 	innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><input id="'+GroupId+'OrderPackQtyz1" name="'+GroupId+'OrderPackQtyz1" Style="WIDTH: 50px; HEIGHT: 22px" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">&nbsp;</input></TD>';
 }else{
 	innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><label id="'+GroupId+'OrderPackQtyz1" name="'+GroupId+'OrderPackQtyz1" Style="WIDTH: 50px; HEIGHT: 22px" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">&nbsp;</label></TD>';
 }
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><label id="'+GroupId+'OrderPackUOMz1" name="'+GroupId+'OrderPackUOMz1" Style="WIDTH: 50px; HEIGHT: 22px">&nbsp;</label></TD>';
 innerHTMLs=innerHTMLs+LookupCellHtml(GroupId+"OrderBillTypez1","",100,"BillType_lookup()","");
 if (ChangeFlag==1){
 	innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz1" name="'+GroupId+'OrderPrescz1" Style="WIDTH: 30px; HEIGHT: 22px" type="checkbox"></input></TD>';
 }else{
 	innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'OrderPrescz1" name="'+GroupId+'OrderPrescz1" Style="WIDTH: 30px; HEIGHT: 22px" CHECKED type="checkbox"></input></TD>';
 }
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><label id="'+GroupId+'OrderMsgz1" name="'+GroupId+'OrderMsgz1" Style="WIDTH: 160px; HEIGHT: 22px">&nbsp;</label></TD>';
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><label id="'+GroupId+'OrderSumz1" name="'+GroupId+'OrderSumz1" Style="WIDTH: 50px; HEIGHT: 22px">&nbsp;</label></TD>';
 innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 50px; HEIGHT: 22px"><select id="'+GroupId+'OrderRecDepz1" name="'+GroupId+'OrderRecDepz1" Style="WIDTH: 50px; HEIGHT: 22px" onchange=\"OrderRecDepchangehandler()\">&nbsp;</select></TD>';
 innerHTMLs=innerHTMLs+"</TR>";
 innerHTMLs=innerHTMLs+"</TBODY>";
 innerHTMLs=innerHTMLs+"</TABLE>";
 innerHTMLs=innerHTMLs+'</TD></TR>'; 
 
 innerHTMLs=innerHTMLs+'<TR><TD>'; 
 innerHTMLs=innerHTMLs+'<TABLE class=tblList  id="'+GroupDId+'" Name="'+GroupDId+'" CELLSPACING=1 width="100%">';
 innerHTMLs=innerHTMLs+'<TR">'; 
 innerHTMLs=innerHTMLs+'<TD width=10%>化疗日期</TD>';
 innerHTMLs=innerHTMLs+LookupCellReadonlyHtml(GroupId+"MultiDate","",630,"MultiDateClickhandler()","");
 //innerHTMLs=innerHTMLs+'<TD width=90%><input id="'+GroupId+'ExecDate" name="GroupDate" Style="HEIGHT: 22px; WIDTH:800px"></input></TD>';
 innerHTMLs=innerHTMLs+'</TR>'; 
 innerHTMLs=innerHTMLs+'<TR style="display:none">'; 
 innerHTMLs=innerHTMLs+'<TD width=10%">组备注信息</TD><TD width=90%><input id="'+GroupId+'Remark" name="'+GroupId+'Remark" Style="HEIGHT: 22px; WIDTH:800px""></input></TD>';
 innerHTMLs=innerHTMLs+'</TR>'; 
 innerHTMLs=innerHTMLs+"</TABLE>";
 innerHTMLs=innerHTMLs+'</TD></TR>';
  
 innerHTMLs=innerHTMLs+"</TABLE>";
 if (ChangeFlag==1){
 	innerHTMLs=innerHTMLs+"<SPAN class='chartitemheading'>&nbsp;<A HREF='#' id='"+GroupId+"AddGroupItem' onclick='AddGroupItem("+Row+");'><IMG SRC='../images/websys/new.gif' BORDER=0>增加药品</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"DeleteGroupItem' onclick='DeleteGroupItem("+Row+");'><IMG SRC='../images/websys/delete.gif'BORDER=0>删除药品</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='ShowRemark("+Row+");'><IMG SRC='../images/websys/new.gif'BORDER=0>录入备注</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroupItem();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroupItem();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='DeleteGroup' onclick='DeleteGroup();'><IMG SRC='../images/websys/delete.gif' BORDER=0><B>删除组</B></A></SPAN>";
 }else{
 	innerHTMLs=innerHTMLs+"<SPAN class='chartitemheading'>&nbsp;<A HREF='#' id='"+GroupId+"AddGroupItem' onclick='AddGroupItem("+Row+");'><IMG SRC='../images/websys/new.gif' BORDER=0>增加药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='"+GroupId+"DeleteGroupItem' onclick='DeleteGroupItem("+Row+");'><IMG SRC='../images/websys/delete.gif'BORDER=0>删除药品</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='ShowRemark("+Row+");'><IMG SRC='../images/websys/new.gif'BORDER=0>录入备注</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroupItem();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroupItem();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移药品</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' id='DeleteGroup' onclick='DeleteGroup();'><IMG SRC='../images/websys/delete.gif' BORDER=0><B>删除组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='UpGroup();'><IMG SRC='../images/websys/cansortasc.gif' BORDER=0><B>上移组</B></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='#' onclick='DownGroup();'><IMG SRC='../images/websys/cansortdesc.gif' BORDER=0><B>下移组</B></A></SPAN>";	
 }
 SheetGroupCell.innerHTML=innerHTMLs;
 return;
	if (!SheetGroupCell.firstChild) {
		SheetGroupCell.appendChild(SheetGroup);
	}else{
		SheetGroupCell.innerHTML=innerHTMLs;
	}
 //document.body.insertBefore(SheetGroup,document.body.firstChild);
}
function LookupCellHtml(cellid,val,cellwidth,keydownname,changename){
	var inputwidth=cellwidth-30;
	var IMGId="ldi"+cellid;
	var str='<TD  STYLE="WIDTH: '+cellwidth+'px; HEIGHT: 22px">';
	var str=str+'<input id=\"'+cellid+'\" name=\"'+cellid+'\" value="'+val+'"Style="WIDTH:'+inputwidth+'px; HEIGHT: 22px" onkeydown=\"'+keydownname+'\" onchange=\"'+changename+'\">&nbsp;</input>';
	var str=str+'<IMG id=\"'+IMGId+'\" name=\"'+IMGId+'\" src=\"../images/websys/lookup.gif\" onclick=\"'+keydownname+'\">';
	var str=str+'</TD>';
	return str;
}
function LookupCellReadonlyHtml(cellid,val,cellwidth,keydownname,changename){
	var inputwidth=cellwidth-30;
	var IMGId="ldi"+cellid;
	var str='<TD  STYLE="WIDTH: '+cellwidth+'px; HEIGHT: 22px">';
	var str=str+'<input id=\"'+cellid+'\" name=\"'+cellid+'\" value="'+val+'"readonly Style="WIDTH:'+inputwidth+'px; HEIGHT: 22px" onkeydown=\"'+keydownname+'\" onchange=\"'+changename+'\">&nbsp;</input>';
	var str=str+'<IMG id=\"'+IMGId+'\" name=\"'+IMGId+'\" src=\"../images/websys/lookup.gif\" onclick=\"'+keydownname+'\">';
	var str=str+'</TD>';
	return str;
}

function LookupCellReadonlyHtmlNew(cellid,val,cellwidth,keydownname,changename){
	var inputwidth=cellwidth-30;
	var IMGId="ldi"+cellid;
	var str='<TD  STYLE="WIDTH: '+cellwidth+'px; HEIGHT: 22px">';
	var str=str+'<input id=\"'+cellid+'\" name=\"'+cellid+'\" value="'+val+'"readonly Style="WIDTH:'+inputwidth+'px; HEIGHT: 22px" onkeydown=\"'+keydownname+'\" onchange=\"'+changename+'\">&nbsp;</input>';
	var str=str+'<IMG id=\"'+IMGId+'\" name=\"'+IMGId+'\" input disabled src=\"../images/websys/lookup.gif\" onclick=\"'+keydownname+'\">';
	var str=str+'</TD>';
	return str;
}

function HiddenTableCellHtml(cellid,cellvalue){
	return '<input disabled id=\"'+cellid+'\" name=\"'+cellid+'\" type="hidden" value=\"'+cellvalue+'\"></input>';
}

function ShowRemark(Row){
	var objtbl=document.getElementById("tGroupD"+Row);
	if (objtbl){
		//objtbl.rows[1].style.visibility="hidden";
		objtbl.rows[1].style.display="block";
	}
}

function ExchangeRows(tGroupId,FromRowIndex,ToRowIndex) {
	SetColumnData(tGroupId,"OrderARCIMRowid",ToRowIndex,GetColumnData(tGroupId,"OrderARCIMRowid",FromRowIndex));
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",ToRowIndex);
	EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetailMehtod,EpisodeID,"","",OrderARCIMRowid);
	var ireclocstr=mPiece(EPARCIMDetail,"^",9);
	var idoseqtystr=mPiece(EPARCIMDetail,"^",11);
	SetColumnList(tGroupId,"OrderDoseUOM",ToRowIndex,idoseqtystr)
	SetColumnList(tGroupId,"OrderRecDep",ToRowIndex,ireclocstr)
	
	SetColumnData(tGroupId,"OrderItemRowid",ToRowIndex,GetColumnData(tGroupId,"OrderItemRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderPriorRowid",ToRowIndex,GetColumnData(tGroupId,"OrderPriorRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderARCIMRowid",ToRowIndex,GetColumnData(tGroupId,"OrderARCIMRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderType",ToRowIndex,GetColumnData(tGroupId,"OrderType",FromRowIndex));
	SetColumnData(tGroupId,"OrderDoseUOMRowid",ToRowIndex,GetColumnData(tGroupId,"OrderDoseUOMRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderFreqRowid",ToRowIndex,GetColumnData(tGroupId,"OrderFreqRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderInstrRowid",ToRowIndex,GetColumnData(tGroupId,"OrderInstrRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderDurFactor",ToRowIndex,GetColumnData(tGroupId,"OrderDurFactor",FromRowIndex));
	SetColumnData(tGroupId,"OrderFreqFactor",ToRowIndex,GetColumnData(tGroupId,"OrderFreqFactor",FromRowIndex));
	SetColumnData(tGroupId,"OrderFreqInterval",ToRowIndex,GetColumnData(tGroupId,"OrderFreqInterval",FromRowIndex));
	SetColumnData(tGroupId,"OrderConFac",ToRowIndex,GetColumnData(tGroupId,"OrderConFac",FromRowIndex));
	SetColumnData(tGroupId,"OrderPackUOMRowid",ToRowIndex,GetColumnData(tGroupId,"OrderPackUOMRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderBaseQty",ToRowIndex,GetColumnData(tGroupId,"OrderBaseQty",FromRowIndex));
	SetColumnData(tGroupId,"OrderBaseQtySum",ToRowIndex,GetColumnData(tGroupId,"OrderBaseQtySum",FromRowIndex));
	SetColumnData(tGroupId,"OrderPHForm",ToRowIndex,GetColumnData(tGroupId,"OrderPHForm",FromRowIndex));
	SetColumnData(tGroupId,"OrderPHPrescType",ToRowIndex,GetColumnData(tGroupId,"OrderPHPrescType",FromRowIndex));
	SetColumnData(tGroupId,"OrderDrugFormRowid",ToRowIndex,GetColumnData(tGroupId,"OrderDrugFormRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderBillTypeRowid",ToRowIndex,GetColumnData(tGroupId,"OrderBillTypeRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderRecDepRowid",ToRowIndex,GetColumnData(tGroupId,"OrderRecDepRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderARCOSRowid",ToRowIndex,GetColumnData(tGroupId,"OrderARCOSRowid",FromRowIndex));
	SetColumnData(tGroupId,"OrderMaxDurFactorz",ToRowIndex,GetColumnData(tGroupId,"OrderMaxDurFactorz",FromRowIndex));
	SetColumnData(tGroupId,"OrderMaxQty",ToRowIndex,GetColumnData(tGroupId,"OrderMaxQty",FromRowIndex));
	SetColumnData(tGroupId,"OrderAlertStockQtyz",ToRowIndex,GetColumnData(tGroupId,"OrderAlertStockQtyz",FromRowIndex));
	SetColumnData(tGroupId,"OrderPoisonCode",ToRowIndex,GetColumnData(tGroupId,"OrderPoisonCode",FromRowIndex));
	SetColumnData(tGroupId,"OrderHiddenPara",ToRowIndex,GetColumnData(tGroupId,"OrderHiddenPara",FromRowIndex));
	
	SetColumnData(tGroupId,"OrderSeqNo",ToRowIndex,GetColumnData(tGroupId,"OrderSeqNo",FromRowIndex));
	SetColumnData(tGroupId,"OrderName",ToRowIndex,GetColumnData(tGroupId,"OrderName",FromRowIndex));
	SetColumnData(tGroupId,"OrderDoseQty",ToRowIndex,GetColumnData(tGroupId,"OrderDoseQty",FromRowIndex));
	SetColumnData(tGroupId,"OrderDoseUOM",ToRowIndex,GetColumnData(tGroupId,"OrderDoseUOM",FromRowIndex));
	SetColumnData(tGroupId,"OrderFreq",ToRowIndex,GetColumnData(tGroupId,"OrderFreq",FromRowIndex));
	SetColumnData(tGroupId,"OrderInstr",ToRowIndex,GetColumnData(tGroupId,"OrderInstr",FromRowIndex));
	SetColumnData(tGroupId,"OrderPrice",ToRowIndex,GetColumnData(tGroupId,"OrderPrice",FromRowIndex));
	SetColumnData(tGroupId,"OrderDepProcNote",ToRowIndex,GetColumnData(tGroupId,"OrderDepProcNote",FromRowIndex));
	SetColumnData(tGroupId,"OrderPackQty",ToRowIndex,GetColumnData(tGroupId,"OrderPackQty",FromRowIndex));
	SetColumnData(tGroupId,"OrderPackUOM",ToRowIndex,GetColumnData(tGroupId,"OrderPackUOM",FromRowIndex));
	SetColumnData(tGroupId,"OrderBillType",ToRowIndex,GetColumnData(tGroupId,"OrderBillType",FromRowIndex));
	SetColumnData(tGroupId,"OrderPresc",ToRowIndex,GetColumnData(tGroupId,"OrderPresc",FromRowIndex));
	SetColumnData(tGroupId,"OrderMsg",ToRowIndex,GetColumnData(tGroupId,"OrderMsg",FromRowIndex));
	SetColumnData(tGroupId,"OrderSum",ToRowIndex,GetColumnData(tGroupId,"OrderSum",FromRowIndex));
	SetColumnData(tGroupId,"OrderRecDep",ToRowIndex,GetColumnData(tGroupId,"OrderRecDep",FromRowIndex));
	SetColumnData(tGroupId,"SolventFlag",ToRowIndex,GetColumnData(tGroupId,"SolventFlag",FromRowIndex));
}

function UpGroupItem(e) {
	var SelRowIndex=GetGroupRowIndex(e);
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var GroupRow=GetGroupRow(objtbl,SelRowIndex);
	if(GroupRow!=FocusGroupIndex) {
		alert(t['No_SelectGroup']); 
		return;
	}
	
	var objtbl=document.getElementById("tGroup"+GroupRow);
	var rows=objtbl.rows.length;
	if ((objtbl)&&(FocusRowIndex>1)){
		var FromRowIndex=FocusRowIndex;
		var ToRowIndex=FocusRowIndex-1;
		var TempRowIndex=rows-1;
		
  	var tGroupId="tGroup"+GroupRow;
  	var Row=GetRow(tGroupId,rows-1);
  	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
  	if (OrderARCIMRowid=="")  return;
		AddGroupItem(GroupRow);
		//alert("FocusRowIndex=="+FocusRowIndex);
		MovedFromRowId=GetRow("tGroup"+GroupRow,FromRowIndex); 
		MovedToRowId=GetRow("tGroup"+GroupRow,ToRowIndex); 
		TempRowId=parseInt(GetRow("tGroup"+GroupRow,TempRowIndex))+1; 
		ExchangeRows("tGroup"+GroupRow,MovedToRowId,TempRowId);
		ExchangeRows("tGroup"+GroupRow,MovedFromRowId,MovedToRowId);
		ExchangeRows("tGroup"+GroupRow,TempRowId,MovedFromRowId);
		FocusRowIndex=rows;
		DeleteGroupItem(GroupRow);	
	}
}

function DownGroupItem(e) {
	var SelRowIndex=GetGroupRowIndex(e);
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var GroupRow=GetGroupRow(objtbl,SelRowIndex);
	if(GroupRow!=FocusGroupIndex) {
		alert(t['No_SelectGroup']); 
		return;
	}
	
	var objtbl=document.getElementById("tGroup"+GroupRow);
	var rows=objtbl.rows.length;
	if ((objtbl)&&(FocusRowIndex<(rows-1))&&(0<FocusRowIndex)){
		var FromRowIndex=FocusRowIndex;
		var ToRowIndex=FocusRowIndex+1;
		var TempRowIndex=rows-1;
		
		var tGroupId="tGroup"+GroupRow;
  	var Row=GetRow(tGroupId,rows-1);
  	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
  	if (OrderARCIMRowid=="")  return;
		AddGroupItem(GroupRow);
		MovedFromRowId=GetRow("tGroup"+GroupRow,FromRowIndex); 
		MovedToRowId=GetRow("tGroup"+GroupRow,ToRowIndex); 
		TempRowId=parseInt(GetRow("tGroup"+GroupRow,TempRowIndex))+1; 
		ExchangeRows("tGroup"+GroupRow,MovedToRowId,TempRowId);
		ExchangeRows("tGroup"+GroupRow,MovedFromRowId,MovedToRowId);
		ExchangeRows("tGroup"+GroupRow,TempRowId,MovedFromRowId);
		FocusRowIndex=rows;
		DeleteGroupItem(GroupRow);
	}
}

///////////////////////////////////////////////////////////////////////////
var FocusRowIndex=0;
var FocusGroupId="";
var FocusGroupIndex=0;
var KeyEnterChangeFocus=0;
var ShowInstrLookup=0;
var CountDelGroup=0;


function MultiDateClickhandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var objtbl=GetEventTable(e);
	SubObjId=objtbl.id.split("D");
	FocusGroupId=SubObjId[0]+SubObjId[1];
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var datestr=DHCC_GetElementData(FocusGroupId+"MultiDate");
		var dateval="";
		if (datestr!="") {
			var dateval=cspRunServerMethod(ConverDateMethod,datestr,1);
		}
		var url='dhcoeorder.selectmultidate.csp?ID=MultiDate&DATEVAL=' + escape(dateval);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=400,height=350');
		return websys_cancel();
	}
}

function ChangeMultiDateClickhandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var objtbl=GetEventTable(e);
	SubObjId=objtbl.id.split("D");
	FocusGroupId=SubObjId[0]+SubObjId[1];
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var datestr=DHCC_GetElementData(FocusGroupId+"ChangeMultiDate");
		var dateval="";
		if (datestr!="") {
			var dateval=cspRunServerMethod(ConverDateMethod,datestr,1);
		}
		var url='dhcoeorder.selectmultidate.csp?ID=ChangeMultiDate&DATEVAL=' + escape(dateval);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=400,height=350');
		return websys_cancel();
	}
}

function MultiDate_lookupSelect(dateval) {
	var datestr=dateval;
	var Cellid=FocusGroupId+"MultiDate";
	if (dateval!=""){
		var datestr=cspRunServerMethod(ConverDateMethod,dateval,0);
	}
	var olddatestr=DHCC_GetElementData(Cellid);
	if (olddatestr!=dateval){
		DHCC_SetElementData(Cellid,datestr);
		var itemtbl=document.getElementById(FocusGroupId);
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var Row=GetRow(FocusGroupId,j);
			SetPackQty(Row);
		}
		if (dateval!=""){
			var datearr=dateval.toString().split(String.fromCharCode(2));
			var SheetStartDateval=GetMinDate();
			var SheetEndDateval=parseFloat(SheetStartDateval)+20;
			SheetStartDate=cspRunServerMethod(ConverDateMethod,SheetStartDateval,4)
			SheetEndDate=cspRunServerMethod(ConverDateMethod,SheetEndDateval,4)		
			DHCC_SetElementData("StartDate",SheetStartDate)
			DHCC_SetElementData("EndDate",SheetEndDate)
		}
	}
}

function GetToday(){
   var d, s="";
   d = new Date();
   s += d.getYear()+"-";
   s += (d.getMonth()+1)+"-";
   s += d.getDate();
   return(s);
}

function ChangeMultiDate_lookupSelect(dateval) {
	var PastDateStr=GetPastMultiDateStr();
	var datestr="";
	var Cellid=FocusGroupId+"ChangeMultiDate";
	if (dateval!=""){
		var datestrTemp=cspRunServerMethod(ConverDateMethod,dateval,0);
	}
	if (PastDateStr!="") {
		datestr=PastDateStr;
		if (dateval!="") {
			datestr=PastDateStr+","+datestrTemp;
		}
	}else{
		if (dateval!="") {
			datestr=datestrTemp;
		}
	}
	var olddatestr=DHCC_GetElementData(Cellid);
	if (olddatestr!=datestr){
		DHCC_SetElementData(Cellid,datestr);
		var itemtbl=document.getElementById(FocusGroupId);
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var Row=GetRow(FocusGroupId,j);
			SetPackQty(Row);	
		}
		if (dateval!=""){
			var datearr=dateval.toString().split(String.fromCharCode(2));
			var SheetStartDateval=GetMinDate();
			var SheetEndDateval=parseFloat(SheetStartDateval)+20;
			SheetStartDate=cspRunServerMethod(ConverDateMethod,SheetStartDateval,4)
			SheetEndDate=cspRunServerMethod(ConverDateMethod,SheetEndDateval,4)		
			DHCC_SetElementData("StartDate",SheetStartDate)
			DHCC_SetElementData("EndDate",SheetEndDate)
		}
	}
}

function GetPastMultiDateStr(){
	// 调整"化疗计划"时,"化疗日期调整为"不仅显示的化疗日期未来的日期,也要显示已执行的日期
	var OrderMultiDate=DHCC_GetElementData(FocusGroupId+"ChangeMultiDate"); //////
	if (OrderMultiDate=="") return "";
	var PastDateStr="";
	var Today=GetToday();
	var SubMultiDate=OrderMultiDate.split(",")
	for (var j=0;j<SubMultiDate.length;j++) {
		var SubMultiVal=cspRunServerMethod(ConverDateMethod,SubMultiDate[j],1);
		var TodayVal=cspRunServerMethod(ConverDateMethod,Today,1);
		if (SubMultiVal<TodayVal){
			if (PastDateStr==""){
				PastDateStr=SubMultiDate[j];
			}else{
				PastDateStr=PastDateStr+","+SubMultiDate[j];
			}
		}
	}
	return PastDateStr;
}

function GetFutureMultiDateStr(FocusGroupId){
	// 调整"化疗计划"增加药品时,取药数量根据"化疗日期调整为"和当前日期判断,只取当前日期和以后的化疗日期
	var ChangeMultiDateObj=document.getElementById(FocusGroupId+'ChangeMultiDate');	
	if (ChangeMultiDateObj){
		var OrderMultiDate=DHCC_GetElementData(FocusGroupId+"ChangeMultiDate");
	}else{
		var OrderMultiDate=DHCC_GetElementData(FocusGroupId+"MultiDate");
	}
	if (OrderMultiDate=="") return "";
	var FutureDateStr="";
	var Today=GetToday();
	var SubMultiDate=OrderMultiDate.split(",")
	for (var j=0;j<SubMultiDate.length;j++) {
		var SubMultiVal=cspRunServerMethod(ConverDateMethod,SubMultiDate[j],1);
		var TodayVal=cspRunServerMethod(ConverDateMethod,Today,1);
		if (SubMultiVal>=TodayVal){
			if (FutureDateStr==""){
				FutureDateStr=SubMultiDate[j];
			}else{
				FutureDateStr=FutureDateStr+","+SubMultiDate[j];
			}
		}
	}
	return FutureDateStr;
}

function GetMinDate() {
	var MinDate=""
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var GroupNo=GetGroupRow(objtbl,i);
		var grouptbl=GetCellObj('SheetGroup',GroupNo);
		var f=websys_getChildElements(grouptbl);
		for (var j=0;j<f.length;j++) {
			if (f[j].tagName=="TABLE") {
				if (f[j].id.substring(0,7)=="tGroupM"){
					var SubObjId=f[j].id.split("tGroupM");
					var GroupRow=SubObjId[1];
				}
			}
		}
		var tGroupId="tGroup"+GroupRow;	
		var ChangeMultiDateObj=document.getElementById(tGroupId+'ChangeMultiDate');		
		if (ChangeMultiDateObj){
			var OrderMultiDate=DHCC_GetElementData(tGroupId+"ChangeMultiDate");
		}else{
			var OrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
		}	
		if (OrderMultiDate!=""){
			OrderMultiDate=cspRunServerMethod(ConverDateMethod,OrderMultiDate,1);
			if (OrderMultiDate!=""){
				var datearr=OrderMultiDate.toString().split(String.fromCharCode(2));
				for (var j=0; j<datearr.length; j++){
					if (MinDate=="") MinDate=datearr[j];
					if (datearr[j]<MinDate){
						MinDate=datearr[j];
					}
				}
			}
		}
	}
	return MinDate;
}

function PHCINDesc_lookuphandler(e) {
	/*
	if (evtName=='OrderInstr') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	*/
	var type=websys_getType(e);
	var key=websys_getKey(e);
  var Row=GetEventRow(e);
  var obj=websys_getSrcElement(e);
  //因为有可能点上一行的放大镜?这是FoucsRowIndex仍是当前行的值所以需要重新取一下
  var Rowobj=getRow(obj);
  if (Rowobj) {FocusRowIndex=Rowobj.rowIndex}
  ShowInstrLookup=0;
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))) {
		var url='websys.lookup.csp';
		url += "?ID=d157iPHCINDesc1";
//		url += "&CONTEXT=Kweb.PHCInstruc:LookUpInstr";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpInstr";
		url += "&TLUJSF=InstrLookUpSelect";
		if (type=='click'){
			url += "&P1=";
		}else{
			var obj=document.getElementById(FocusGroupId+'OrderInstrz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}
		ShowInstrLookup=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
				SetFocusColumn(FocusGroupId,"OrderPackQty",Row);
		}
	}
}

function InstrLookUpSelect(value) {
	//alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusGroupId,FocusRowIndex);
	try {
		var OrderInstr=unescape(Split_Value[1]);
		var OrderInstrRowid=Split_Value[0];
		var obj=document.getElementById(FocusGroupId+'OrderInstrz'+Row);
		if (obj) {
  			obj.value=OrderInstr;
		  	obj.className='';
		}
		SetColumnData(FocusGroupId,"OrderInstrRowid",Row,OrderInstrRowid);
		// 用法一致
		var VenousFillingFlag=DHCC_GetElementData(FocusGroupId+"VenousFillingFlag");
		if (VenousFillingFlag==false){
			var itemtbl=document.getElementById(FocusGroupId);
			var itemrows=itemtbl.rows.length;
			var Row=GetRow(FocusGroupId,1);
			var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
			if (OrderItemRowid!="") {
				var OrderInstrRowid=GetColumnData(FocusGroupId,"OrderInstrRowid",Row);
				var OrderInstr=GetColumnData(FocusGroupId,"OrderInstr",Row);
			}	
	    ChangeLinkOrderInstr(OrderInstrRowid,OrderInstr);	
		}
    // 用法一致
		if (ShowInstrLookup==1) SetFocusColumn(FocusGroupId,"OrderPackQty",Row);
	} catch(e) {};
}

function ChangeLinkOrderInstr(OrderInstrRowid,OrderInstr){
  try{
		var itemtbl=document.getElementById(FocusGroupId);
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
	    var Row=GetRow(FocusGroupId,j);
			var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
			if (OrderItemRowid==""){
				SetColumnData(FocusGroupId,"OrderInstr",Row,OrderInstr);
	    	SetColumnData(FocusGroupId,"OrderInstrRowid",Row,OrderInstrRowid);
		    SetPackQty(Row);
			} 
		}
	}catch(e){alert(e.message)}
}

function InstrChangeHandler(e){
	evtName='OrderInstr';
	var evtSrcElm=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(evtSrcElm);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	PHCINDesc_lookuphandlerX(LookUpInstrMethod); evtTimer="";
}

function PHCINDesc_lookuphandlerX(encmeth) {
	/*
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	*/
	var Row=GetRow(FocusGroupId,FocusRowIndex);
	SetColumnData(FocusGroupId,"OrderInstrRowid",Row,"");
	var Id=FocusGroupId+'OrderInstrz'+Row;
	var obj=document.getElementById(Id);
	if (obj.value!='') {
		var tmp=document.getElementById(Id);
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'InstrLookUpSelect','',p1)=='0') {
			obj.className='clsInvalid';
			SetColumnData(FocusGroupId,"OrderInstrRowid",Row,"");
			websys_setfocus(Id);
			return websys_cancel();
		}
	}
	obj.className='';
}

function PHCFRDesc_lookuphandler(e) {
	/*
	if (evtName=='OrderFreq') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	*/
	ShowFreqLookup=0;
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))){
		var url='websys.lookup.csp';
		url += "?ID=d157iPHCFRDesc1";
		//url += "&CONTEXT=Kweb.PHCFreq:LookUpFrequency";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpFrequency";
		url += "&TLUJSF=FrequencyLookUpSelect";
		if (type=='click') {
			if (obj) url += "&P1=" ;
		}else{
			var obj=document.getElementById(FocusGroupId+'OrderFreqz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}
		ShowFreqLookup=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
			SetFocusColumn(FocusGroupId,"OrderInstr",Row);
		}
	}		
}

function FrequencyLookUpSelect(value) {
	var Split_Value=value.split("^");
	var Row=GetRow(FocusGroupId,FocusRowIndex);
	try {
    var OrderFreq=Split_Value[0];
    var OrderFreqFactor=Split_Value[2];
    var OrderFreqInterval=Split_Value[3];
    var OrderFreqRowid=Split_Value[4];
    var OrderFreqDispTimeStr=Split_Value[5];

		SetColumnData(FocusGroupId,"OrderFreq",Row,OrderFreq);
		SetColumnData(FocusGroupId,"OrderFreqFactor",Row,OrderFreqFactor);
		SetColumnData(FocusGroupId,"OrderFreqInterval",Row,OrderFreqInterval);
		SetColumnData(FocusGroupId,"OrderFreqRowid",Row,OrderFreqRowid);
		var obj=document.getElementById(FocusGroupId+'OrderFreqz'+Row);
		if (obj) obj.className='';

		//websys_nextfocusElement(obj);
		SetPackQty(Row);
		// 频次一致
		var VenousFillingFlag=DHCC_GetElementData(FocusGroupId+"VenousFillingFlag");
		if (VenousFillingFlag==false){
			var itemtbl=document.getElementById(FocusGroupId);
			var itemrows=itemtbl.rows.length;
			var Row=GetRow(FocusGroupId,1);
			var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
			if (OrderItemRowid!="") {
				var OrderFreqRowid=GetColumnData(FocusGroupId,"OrderFreqRowid",Row);
				var OrderFreq=GetColumnData(FocusGroupId,"OrderFreq",Row);
				var OrderFreqFactor=GetColumnData(FocusGroupId,"OrderFreqFactor",Row);
				var OrderFreqInterval=GetColumnData(FocusGroupId,"OrderFreqInterval",Row);
			}			
			ChangeLinkOrderFreq(OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr);	
		}
		// 频次一致
		if (ShowFreqLookup==1) SetFocusColumn(FocusGroupId,"OrderInstr",Row);
	} catch(e) {alert(e.message)};
}

function ChangeLinkOrderFreq(OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr){
  try{
		var itemtbl=document.getElementById(FocusGroupId);
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var Row=GetRow(FocusGroupId,j);
			var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
			if (OrderItemRowid==""){
				SetColumnData(FocusGroupId,"OrderFreq",Row,OrderFreq);
				SetColumnData(FocusGroupId,"OrderFreqRowid",Row,OrderFreqRowid);
		    SetColumnData(FocusGroupId,"OrderFreqFactor",Row,OrderFreqFactor);
		    SetColumnData(FocusGroupId,"OrderFreqInterval",Row,OrderFreqInterval);
		    SetPackQty(Row);
			} 
		}
	}catch(e){alert(e.message)}
}

function FrequencyChangeHandler(){
	evtName='OrderFreq';
	var evtSrcElm=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(evtSrcElm);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	PHCFRDesc_changehandlerX(LookUpFrequencyMethod); evtTimer="";
	return;
}

function PHCFRDesc_changehandlerX(encmeth) {
	/*
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	*/
	var Row=GetRow(FocusGroupId,FocusRowIndex);
	SetColumnData(FocusGroupId,"OrderFreqRowid",Row,"");
	var Id=FocusGroupId+'OrderFreqz'+Row;
	var obj=document.getElementById(Id);
	if (obj.value!='') {
		var tmp=document.getElementById(Id);
		if (tmp) {var p1=tmp.value } else {var p1=''};
		//if (cspRunServerMethod(encmeth,'PHCFRDesc1_lookupsel','FrequencyLookUpSelect',p1)=='0') {

		if (cspRunServerMethod(encmeth,'FrequencyLookUpSelect','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus(Id);
			return websys_cancel();
		}
	}
	obj.className='';
}

function OrderDoseUOMchangehandler(e){
	var Row=GetEventRow(e);
	var UOMListObj=websys_getSrcElement(e);
	var selIndex=UOMListObj.selectedIndex;
	var UOMRowid=""
	if (selIndex!=-1) {UOMRowid=UOMListObj.options[selIndex].value;}
	//alert(Row+"^"+UOMRowid);
	SetColumnData(FocusGroupId,"OrderDoseUOMRowid",Row,UOMRowid);
}

function OrderRecDepchangehandler(e){
	var Row=GetEventRow(e);
	var RecDepObj=websys_getSrcElement(e);
	var selIndex=RecDepObj.selectedIndex;
	var RecDepRowid=""
	if (selIndex!=-1) {RecDepRowid=RecDepObj.options[selIndex].value;}
	//alert(Row+"^"+RecDepRowid);
	SetColumnData(FocusGroupId,"OrderRecDepRowid",Row,RecDepRowid);
}

function OrderBillTypechangehandler(e){
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var selIndex=obj.selectedIndex;
	var BillTypeRowid=""
	if (selIndex!=-1) {BillTypeRowid=obj.options[selIndex].value;}
	//alert(Row+"^"+RecDepRowid);
	SetColumnData(FocusGroupId,"OrderBillTypeRowid",Row,BillTypeRowid);	
}

function OrderDoseQtychangehandler(e)
{
	try {
		var Row=GetEventRow(e);
	  var OrderType=GetColumnData(FocusGroupId,"OrderType",Row);
	  var OrderDoseQty=GetColumnData(FocusGroupId,"OrderDoseQty",Row);
	  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
	  //alert("OrderType="+OrderType+"    OrderDoseQty="+OrderDoseQty+"    OrderARCIMRowid="+OrderARCIMRowid+"    Row="+Row);
	  if ((OrderType=="R")&&(OrderDoseQty!="")&&(OrderARCIMRowid!="")){
	  	SetPackQty(Row);
	  }
	}catch(e) {}
}

function OrderDoseQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//alert(keycode);
	try {
		if ((keycode==13)||(keycode==9)){
			var Row=GetEventRow(e);
		  var OrderType=GetColumnData(FocusGroupId,"OrderType",Row);
		  var OrderDoseQty=GetColumnData(FocusGroupId,"OrderDoseQty",Row);
		  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
		  var OrderPHPrescType=GetColumnData(FocusGroupId,"OrderPHPrescType",Row);
		  //alert(OrderARCIMRowid);
		  if (OrderARCIMRowid!=""){
	  		websys_setfocus(FocusGroupId+"OrderFreqz"+Row);
			}
			return websys_cancel();
		}
	}catch(e) {}
}

function OrderPackQtykeypresshandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
}

function OrderPackQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}

	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		try {
			if ((keycode==13)||(keycode==9)){
				window.event.keyCode=0;
				var Row=GetEventRow(e);
			  var OrderPackQty=GetColumnData(FocusGroupId,"OrderPackQty",Row);
			  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
			  if (OrderARCIMRowid!=""){
    			if ((PAAdmType=="I")||((PAAdmType!="I")&&(OrderPackQty!=""))){
    				var objtbl=document.getElementById(FocusGroupId);
    				AddRowToList(objtbl);
			  		//window.setTimeout("AddTableRow('"+FocusGroupId+"')",200);
			  	}
				}
				return websys_cancel();
			}
		}catch(e) {}
	}else{
		return websys_cancel();
	}
}

function OrderPackQtychangehandler(e){ 
	var eSrc=websys_getSrcElement(e);
	try {
			var Row=GetEventRow(e);
		  var OrderPackQty=GetColumnData(FocusGroupId,"OrderPackQty",Row);
		  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
		  var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
		  var OrderPriorRowid=GetColumnData(FocusGroupId,"OrderPriorRowid",Row);
		  if (OrderPackQty==""){OrderPackQty=0}
		  if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				var OrderPrice=GetColumnData(FocusGroupId,"OrderPrice",Row);
				var OrderSum=parseFloat(OrderPrice)*parseFloat(OrderPackQty);
				OrderSum=OrderSum.toFixed(4);
				//如果是自备药医嘱则不用再计算金额
				if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
					SetColumnData(FocusGroupId,"OrderSum",Row,OrderSum);
					SetScreenSum();
				}
			}
			return websys_cancel();
	}catch(e) {}
}

function OrderPricekeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}

	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		try {
			if ((keycode==13)||(keycode==9)){
				var Row=GetEventRow(e);
			  var OrderPackQty=GetColumnData(FocusGroupId,"OrderPackQty",Row);
			  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
			  if (OrderARCIMRowid!=""){
			  	websys_setfocus(FocusGroupId,"OrderPackQtyz"+Row);
				}
				return websys_cancel();
			}
		}catch(e) {}
	}else{
		return websys_cancel();
	}
}
function OrderPricechangehandler(e){ 
	var eSrc=websys_getSrcElement(e);
	try {
			var Row=GetEventRow(e);
		  var OrderPackQty=GetColumnData(FocusGroupId,"OrderPackQty",Row);
		  var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row);
		  var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
		  if (OrderPackQty==""){OrderPackQty=0}
		  if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				var OrderPrice=GetColumnData(FocusGroupId,"OrderPrice",Row);
				var OrderSum=parseFloat(OrderPrice)*parseFloat(OrderPackQty);
				OrderSum=OrderSum.toFixed(4);
				//alert(OrderSum);
				SetColumnData(FocusGroupId,"OrderSum",Row,OrderSum);
				SetScreenSum();
			}
			return websys_cancel();
	}catch(e) {}
}
function OEORIDoseQty_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidCurrency(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('OEORIDoseQty');
		return websys_cancel();
	} else {
		eSrc.className='';
	}
}

function SetPackQty(Row) {
	var OrderItemRowid=GetColumnData(FocusGroupId,"OrderItemRowid",Row);
	if ((OrderItemRowid!="")&&(ChangeFlag==1)) return true;	
	
  var OrderType=GetColumnData(FocusGroupId,"OrderType",Row);
  var OldOrderPackQty=GetColumnData(FocusGroupId,"OrderPackQty",Row);
	var OrderConFac=GetColumnData(FocusGroupId,"OrderConFac",Row);
	var OrderPrice=GetColumnData(FocusGroupId,"OrderPrice",Row);
	var OrderPriorRowid=GetColumnData(FocusGroupId,"OrderPriorRowid",Row);
	var OrderStartDate=GetColumnData(FocusGroupId,"OrderStartDate",Row);
	var OrderMultiDate=DHCC_GetElementData(FocusGroupId+"MultiDate");
	if (ChangeFlag==1) OrderMultiDate=GetFutureMultiDateStr(FocusGroupId);
	
	if (OrderPrice=="") OrderPrice=0;
 //alert("OrderType="+OrderType+"    OldOrderPackQty="+OldOrderPackQty+"    OrderConFac="+OrderConFac+"    OrderPrice="+OrderPrice);
 //alert("OrderPriorRowid="+OrderPriorRowid+"   OrderStartDate="+OrderStartDate+"    OrderMultiDate="+OrderMultiDate);
  if (OrderType=="R"){
  	var OrderAutoCalculate=GetColumnData(FocusGroupId,"OrderAutoCalculate",Row);
	  var OrderDoseQty=GetColumnData(FocusGroupId,"OrderDoseQty",Row);
	  var freq=GetColumnData(FocusGroupId,"OrderFreqFactor",Row);   
		var dur=GetColumnData(FocusGroupId,"OrderDurFactor",Row);
		//alert("OrderAutoCalculate"+OrderAutoCalculate+"   OrderDoseQty="+OrderDoseQty+"    freq="+freq+"    dur="+dur);
		//如果是通过选择日期则需要计算天数
		if (OrderMultiDate!=""){
			var DateArr=OrderMultiDate.split(",");
			dur=DateArr.length;
		}else{
			dur=1;
		}

	  var Interval=GetColumnData(FocusGroupId,"OrderFreqInterval",Row);
		var DrugFormRowid=GetColumnData(FocusGroupId,"OrderDrugFormRowid",Row);
		var OrderDoseUOMRowid=GetColumnData(FocusGroupId,"OrderDoseUOMRowid",Row);
		var FreqDispTimeStr=GetColumnData(FocusGroupId,"OrderFreqDispTimeStr",Row); 
		var PackQty=1;
		var BaseDoseQty=1;
		if ((Interval!="") && (Interval!=null)) {
			var convert=Number(dur)/Number(Interval)
			var fact=(Number(dur))%(Number(Interval));
			if (fact>0) {fact=1;} else {fact=0;}
			dur=Math.floor(convert)+fact;
		}
		if (OrderDoseQty!=""){
	  	var valDoseQty=parseFloat(OrderDoseQty);
			//alert(valDoseQty+"^"+freq+"^"+dur+"^"+Interval+"^"+DrugFormRowid+"^"+OrderDoseUOMRowid+"^"+OrderConFac);
		  if (freq=="") freq=1;
			if (CalDoseMethod!=''){
				//alert("OrderDoseUOMRowid="+OrderDoseUOMRowid+"  DrugFormRowid="+DrugFormRowid+"  valDoseQty="+valDoseQty);
				BaseDoseQty=cspRunServerMethod(CalDoseMethod,OrderDoseUOMRowid,DrugFormRowid,valDoseQty);
				//alert("DrugFormRowid:"+DrugFormRowid+"  BaseDoseQty: "+BaseDoseQty+"   ItemConFac "+OrderConFac+"    valDoseQty:"+valDoseQty);
				if (BaseDoseQty=="") BaseDoseQty=1
				try{
					var NumTimes=1;
					if (FreqDispTimeStr!=""){
						//NumTimes=GetCountByFreqDispTime(FreqDispTimeStr,OrderStartDate,dur);
					}else{
						NumTimes=parseFloat(freq) * parseFloat(dur);
					}
					//alert("NumTimes :"+NumTimes+"BaseDoseQtySum :"+BaseDoseQty);
					var BaseDoseQtySum = parseFloat(BaseDoseQty) * parseFloat(NumTimes);
			   // alert("BaseDoseQtySum :"+BaseDoseQtySum);
			    PackQty=parseFloat(parseFloat(BaseDoseQtySum)/parseFloat(OrderConFac));
					PackQty=PackQty.toFixed(4);
					PackQty=Math.ceil(PackQty);
			    //alert("BaseDoseQtySum: "+BaseDoseQtySum+"   PackQty: "+PackQty)
			    //RoundUpNum=Math.ceil(valDoseQty);
			  }catch(e){alert(e.message)}
			}
		}
	}else{
		var freq=GetColumnData(FocusGroupId,"OrderFreqFactor",Row); 
		var dur=GetColumnData(FocusGroupId,"OrderDurFactor",Row);
	  var Interval=GetColumnData(FocusGroupId,"OrderFreqInterval",Row);
		if ((Interval!="") && (Interval!=null)) {
			var convert=Number(dur)/Number(Interval)
			var fact=(Number(dur))%(Number(Interval));
			if (fact>0) {fact=1;} else {fact=0;}
			dur=Math.floor(convert)+fact;
		}
		var OrderDoseQty=GetColumnData(FocusGroupId,"OrderDoseQty",Row);
		if (OrderDoseQty=="") OrderDoseQty=1;
		if ((dur==0)||(dur=="")){dur=1}
		PackQty=parseFloat(freq)*parseFloat(dur)*parseFloat(OrderDoseQty);
		PackQty=Math.ceil(PackQty);
		BaseDoseQtySum=PackQty;
		BaseDoseQty="";
		
	}
	
	if (PAAdmType=="I") {
		//如果已经有整包装或者是自备药医嘱则不用去计算金额
		if (((OldOrderPackQty!="")&&(OrderType=="R"))||(OrderPriorRowid==OMOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid)) {
			return true;
		}else{
		  var OrderSum=(parseFloat(OrderPrice)/parseFloat(OrderConFac))*parseFloat(BaseDoseQtySum);
		  OrderSum=OrderSum.toFixed(4);
			SetColumnData(FocusGroupId,"OrderBaseQty",Row,BaseDoseQty);	
			SetColumnData(FocusGroupId,"OrderBaseQtySum",Row,BaseDoseQtySum);
			if (OrderType!="R") SetColumnData(FocusGroupId,"OrderPackQty",Row,PackQty);
			SetColumnData(FocusGroupId,"OrderSum",Row,OrderSum);
		}	
	}else{
		if (PackQty<0) {PackQty=1}
		var OrderSum=parseFloat(OrderPrice)*PackQty;
		OrderSum=OrderSum.toFixed(4);
		SetColumnData(FocusGroupId,"OrderPackQty",Row,PackQty);
		SetColumnData(FocusGroupId,"OrderBaseQty",Row,BaseDoseQty);
		SetColumnData(FocusGroupId,"OrderBaseQtySum",Row,BaseDoseQtySum);
		SetColumnData(FocusGroupId,"OrderSum",Row,OrderSum);
	}
	SetScreenSum();
	return true;	
}

function SetScreenSum(){
	var amount=0;
	return amount;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemSum=GetColumnData("OrderSum",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderPackQty=GetColumnData("OrderPackQty",Row);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			amount=amount+parseFloat(OrderItemSum);
		}
	}	
  /*
	if (amount==0){
			var OrderItemSum=document.getElementById("OrderItemSum");
			if (OrderItemSum)	{OrderItemSum.value=0;}
	}
  */
	amount=amount.toFixed(2);
	var ToBillSum=GetToBillSum();
	var TotalToBillSum=parseFloat(ToBillSum)+parseFloat(amount);
	TotalToBillSum=TotalToBillSum.toFixed(2);
	SetTotalToBillSum(TotalToBillSum);
	//alert("ToBillSum:"+ToBillSum+"amount:"+amount+"TotalToBillSum:"+TotalToBillSum);
	var obj_ScreenBillSum=document.getElementById('ScreenBillSum');
	if (obj_ScreenBillSum) {obj_ScreenBillSum.value=amount;}
	CheckAccInfo(TotalToBillSum);
}
function xItem_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	/*
	if (evtName=='OrderName') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	*/
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		//if (!CheckDiagnose()) return;

		var obj=websys_getSrcElement(e);
		var Row=GetEventRow(e);
		
		var url='websys.lookup.csp';
		url += "?ID=d50013iOrderNamez"+Row;
		//url += "?ID=d50013iItem";
		//url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		url += "&CONTEXT=Kweb.DHCDocOrderEntry:LookUpItem";
		url += "&TLUJSF=OrderItemLookupSelect";
		//var obj=document.getElementById('OrderNamez'+Row);
		//var OrderName=obj.value;

	    var obj=document.getElementById('tGroup'+Row+'OrderNamez'+Row);
		var OrderName=obj.value;
		if (OrderName=="*"){OrderName=""}
		if (OrderName==""){return false}

		//if (obj) url += "&P1=" + websys_escape(OrderName);
		url += "&P1=" + websys_escape(OrderName);

		var obj=document.getElementById('GroupID');

		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById("catID");
		if (obj) url += "&P3=" + websys_escape(obj.value);
		//if (obj) url += "&P3=" ;
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		//if (obj) url += "&P4=";

		var obj=document.getElementById('TYPE');
		if (obj) url += "&P5="+ websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value);
		websys_lu(url,1,'');

		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==9)){
			var obj=websys_getSrcElement(e);
			var OrderName=obj.value;
			if (OrderName==""){
				websys_setfocus(obj.id);
			  return websys_cancel();
			}
		}
	}
}
function BillType_lookup(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);

	var Row=GetEventRow(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var obj=websys_getSrcElement(e);
		var Row=GetEventRow(e);
		var url='websys.lookup.csp';
		url += "?ID=d50013iOrderNamez"+Row;
		url += "&CONTEXT=Kweb.DHCPAAdmSheets:LookUpBillType";
		url += "&TLUJSF=BillTypeLookupSelect";
		if (EpisodeID==""){return false}
		if (obj) url += "&P1=" + websys_escape(EpisodeID);
		var OrderARCIMRowid=GetColumnData(FocusGroupId,"OrderARCIMRowid",Row)
		if (obj) url += "&P2=" + websys_escape(OrderARCIMRowid);
		websys_lu(url,1,'');
		return websys_cancel();
	}
	
}

function BillTypeLookupSelect(value){
	var Split_Value=value.split("^");
	var Row=GetRow(FocusGroupId,FocusRowIndex);
	try {
    var BillTypeRowid=Split_Value[0];
    var BillType=Split_Value[1];
	
		SetColumnData(FocusGroupId,"OrderBillTypeRowid",Row,BillTypeRowid);
		SetColumnData(FocusGroupId,"OrderBillType",Row,BillType);
	} catch(e) {alert(e.message)};
}

////////////////////////////////////////////////////////////////
function GetEventRow(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;

	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);

	FocusRowIndex=TRSrc.rowIndex;
	var TBSrc=websys_getParentElement(TRSrc);
	var TBSrc=websys_getParentElement(TBSrc);
	FocusGroupId=TBSrc.id;
	return Row
}

function GetEventTable(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;

	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);

	var TBSrc=websys_getParentElement(TRSrc);
	var TBSrc=websys_getParentElement(TBSrc);
	
	var TabName=TBSrc.id;
	if (TabName.substring(0,7)=="tGroupD"){
		FocusGroupIndex=TabName.substring(7,TabName.length);
	}else{
		FocusGroupIndex=TabName.substring(6,TabName.length)
	}
	return TBSrc;
}

function GetRow(TabName,Rowindex){
	var objtbl=document.getElementById(TabName);
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			//alert("Id="+Id+"       "+arrId[arrId.length-1]);
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}

function ClearRow(TabName,Rowindex){
	var objtbl=document.getElementById(TabName);
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
			if (rowitems[j].tagName=='LABEL'){
				if (arrId[0]!=(TabName+"OrderSeqNo")) {
				  rowitems[j].innerText=""
				}
			}else{
				rowitems[j].value="";
			}
		}
	}
	SetFocusColumn(TabName,"OrderName",Row);
	return Row;
}	

function SetFocusColumn(TabName,ColName,Row){
	var obj=document.getElementById(TabName+ColName+"z"+Row);
	if (obj){websys_setfocus(TabName+ColName+"z"+Row)};
}

function GetColumnData(TabName,ColName,Row){
	var CellObj=document.getElementById(TabName+ColName+"z"+Row);
	if (CellObj){ 
		//if (ColName=="OrderARCIMRowid") alert(TabName+ColName+"z"+Row+"     CellObj.tagName="+CellObj.tagName+"   Row="+Row+"    CellObj.id="+CellObj.id+"    CellObj.value="+CellObj.value);
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

function SetColumnData(TabName,ColName,Row,Val){
	var CellObj=document.getElementById(TabName+ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
			if (ColName=="OrderBillTypeRowId"){
				var BillTypeRowid=GetColumnData(TabName,"OrderBillTypeRowid",Row);
			}
		}
	}
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

function SetColumnList(TabName,ColumnName,Row,str) {
	  var Id=TabName+ColumnName+"z"+Row;
    var obj=document.getElementById(Id);
    if ((obj)&&(obj.type=="select-one")){
    	 ClearAllList(obj);
    	 if (ColumnName=="OrderRecDep"){
    	 	 var DefaultRecLocRowid="";
    	 	 var DefaultRecLocDesc="";
	       var ArrData=str.split(String.fromCharCode(2));
	       for (var i=0;i<ArrData.length;i++) {
	       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       	 if (ArrData1[2]=="Y") {
	       	 	 var DefaultRecLocRowid=ArrData1[0];
	       	 	 var DefaultRecLocDesc=ArrData1[1];
	       	 }
	         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	       SetColumnData(TabName,"OrderRecDepRowid",Row,DefaultRecLocRowid);
	       SetColumnData(TabName,"OrderRecDep",Row,DefaultRecLocRowid);
	     }
    	 if (ColumnName=="OrderDoseUOM"){
    	 	 var DefaultDoseQty="";
    	 	 var DefaultDoseQtyUOM=""
    	 	 var DefaultDoseUOMRowid="";
    	 	 if (str!=""){
		       var ArrData=str.split(String.fromCharCode(2));
		       for (var i=0;i<ArrData.length;i++) {
		       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[2]);
		         if (i==0) {
		         	var DefaultDoseQty=ArrData1[0];
		         	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
		         	var DefaultDoseUOMRowid=RowidData=ArrData1[2];
		        }
		       }
		      }  	
	       SetColumnData(TabName,"OrderDoseQty",Row,DefaultDoseQty);
	       SetColumnData(TabName,"OrderDoseUOM",Row,DefaultDoseUOMRowid);	       
	       SetColumnData(TabName,"OrderDoseUOMRowid",Row,DefaultDoseUOMRowid);
	     }
    	 if (ColumnName=="OrderBillType"){
     	 	 var DefaultBillTypeRowid="";
    	 	 var DefaultBillTypeDesc="";
	       var ArrData=str.split(String.fromCharCode(2));
	       for (var i=0;i<ArrData.length;i++) {
	       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       	 if (ArrData1[2]=="Y") {
	       	 	 var DefaultBillTypeRowid=ArrData1[0];
	       	 	 var DefaultBillTypeDesc=ArrData1[1];
	       	 }
	         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	       SetColumnData(TabName,"OrderBillTypeRowid",Row,DefaultBillTypeRowid);
	       SetColumnData(TabName,"OrderBillType",Row,DefaultBillTypeRowid);
	     }	     
    }
}
///////////////////////////////////////////////////////////////////

function OrderItemLookupSelect(txt) { 
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	//OrderType for example:"R"
	var isubcatcode=adata[5];
	//alert("isubcatcode "+isubcatcode)
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];
	var idur=adata[12];
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	var OSItemIDs=adata[15];
	var iorderSubCatID=adata[16];
	//alert(mPiece(OSItemIDs,String.fromCharCode(12),1));
  //alert(txt);
	window.focus();
  var Row=GetRow(FocusGroupId,FocusRowIndex);
	if (!CheckDiagnose(isubcatcode)){
		var itemobj=document.getElementById(FocusGroupId+"OrderNamez"+Row);
		if (itemobj) {
			itemobj.value="";
			websys_setfocus(itemobj.id);
			return false;
		}
	} 
      
	if (iordertype=="ARCIM") iSetID="";
	var Itemids="";
        
	if(OSItemIDs=="") Itemids=icode;
	else Itemids=icode+String.fromCharCode(12)+OSItemIDs;
	//alert("Itemids"+Itemids+"icode"+icode+"OSItemIDs"+OSItemIDs);

	//var DupMsg=ShouldAddItem(Itemids,idesc);
	//cDupMsg=icode+"^"+DupMsg+String.fromCharCode(4);
	// move the duplicate order check to summaryscreen
	//OSItemIDs is Combinded as Aricmrowid+String.fromCharCode(14)+arcimdesc, code below remove arcimdesc,left arcimrowid
	var OSItemIDArr=OSItemIDs.split(String.fromCharCode(12))
	for (var i=0;i<OSItemIDArr.length;i++) {
		if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i]=OSItemIDArr[i].split(String.fromCharCode(14))[1];
	}
	OSItemIDs=OSItemIDArr.join(String.fromCharCode(12));
	//alert(lstOrders.length+","+icode+","+idesc+","+isubcatcode+","+iordertype+","+ialias+","+""+","+iSetID+","+iorderCatID+","+idur+","+SetRef+","+OSItemIDs+","+iorderSubCatID);
	//AgeSexRestrictionCheck(icode,idesc,isubcatcode,idur,match,"",iordertype);

	if (iordertype=="ARCIM"){
    var Para="";
	  var ret=AddItemToList(FocusGroupId,FocusRowIndex,icode,Para);
		if (ret==false) {
			ClearRow(FocusGroupId,FocusRowIndex);
			return;
		}

    var OrderType=GetColumnData(FocusGroupId,"OrderType",Row);
    if (OrderType=="R") {
    	SetFocusColumn("OrderDoseQty",Row);
    }else{
    	if (OrderType=="P") {
    		SetFocusColumn(FocusGroupId,"OrderPrice",Row);
    	}else{
    		SetFocusColumn(FocusGroupId,"OrderPackQty",Row);
    	}
    }
		return true;
	}else{
		ClearRow(FocusGroupId,FocusRowIndex);
		OSItemListOpen(icode,"","YES","","");
	}
}

function CheckDiagnose(ordertype){
	//if ((PAAdmType=="I")&&(IPOrderPhamacyWithDiagnos!="1")) {return true;}
	//if (OrderPhamacyWithDiagnos!="1"){return true;}
	var MRDiagnoseCount=0;
	var mradm=document.getElementById('mradm').value;
	var GetMRDiagnoseCount=document.getElementById('GetMRDiagnoseCount');
	if ((GetMRDiagnoseCount)&&(mradm!='')) {
		var encmeth=GetMRDiagnoseCount.value;
		MRDiagnoseCount=cspRunServerMethod(encmeth,mradm);
	}
	//if ((MRDiagnoseCount==0)&&(ordertype=="R")) {
	if (MRDiagnoseCount==0) {
		if ((t['NO_DIAGNOSE'])&&(t['NO_DIAGNOSE']!="")) {
		alert(t['NO_DIAGNOSE']);}
		return false;
	}
	return true;
}

function OSItemListOpen(ARCOSRowid,OSdesc,del,itemtext,OrdRowIdString) {
	var Patient = "";
	var EpisodeID="";

	var patobj=document.getElementById("PatientID");
	if (patobj) Patient=patobj.value;
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID)	EpisodeID=objEpisodeID.value;
	if (ARCOSRowid!="") {
		var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.OSItem&EpisodeID="+EpisodeID+"&ARCOSRowid="+ARCOSRowid;
		//alert("path="+path);
		websys_createWindow(path,"frmOSList","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=100,width=500,height=600")
	}

}

function AddItemToList(TabName,RowIndex,icode,Para) {	  //Add an item to a listbox
	//alert("TabName="+TabName+"  RowIndex="+RowIndex+"   icode="+icode+"   Para="+Para);
	var BillGrpDesc="";
	var ARCIMDetail="";
  var PackQty="1";
  var OrderBillTypeRowid=""
  var OrderRecDepRowid=""
	
	//如果按登录科室取接收科室?就把登录科室传进去
	var obj=document.getElementById("FindByLogDep");
	if (obj){
		if (obj.checked){FindRecLocByLogonLoc=1}else{FindRecLocByLogonLoc=0}
	}
	var LogonDep=""
  if (FindRecLocByLogonLoc=="1"){LogonDep=session['LOGON.CTLOCID']}
  var Row=GetRow(TabName,RowIndex);
  //alert(EpisodeID+"^"+OrderBillTypeRowid+"^"+LogonDep+"^"+icode);
  //if (PAAdmType!="I"){OrderBillTypeRowid=GetPrescBillTypeID();}
  var EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetailMehtod,EpisodeID,OrderBillTypeRowid,LogonDep,icode);

  var idesc=mPiece(EPARCIMDetail,"^",0);
  var OrderType=mPiece(EPARCIMDetail,"^",1);
  var OrderItemCatRowid=mPiece(EPARCIMDetail,"^",2);
  var InciRowid=mPiece(EPARCIMDetail,"^",4);
  var OrderPHPrescType=mPiece(EPARCIMDetail,"^",5);
  var OrderBillType=mPiece(EPARCIMDetail,"^",6);
  var iretPrice=mPiece(EPARCIMDetail,"^",7)
  var ipackqtystr=mPiece(EPARCIMDetail,"^",8);
  var ireclocstr=mPiece(EPARCIMDetail,"^",9);
  var iformstr=mPiece(EPARCIMDetail,"^",10);
  var idoseqtystr=mPiece(EPARCIMDetail,"^",11);
  var ifrequencestr=mPiece(EPARCIMDetail,"^",12);
  var iinstructionstr=mPiece(EPARCIMDetail,"^",13);
  var idurationstr=mPiece(EPARCIMDetail,"^",14);
  var idefpriorstr=mPiece(EPARCIMDetail,"^",15);
  var iordermsg=mPiece(EPARCIMDetail,"^",16);
  var realstockqty=mPiece(EPARCIMDetail,"^",17);
  var ilab=mPiece(EPARCIMDetail,"^",18);
  var iskintest=mPiece(EPARCIMDetail,"^",19);
  var iinsurinfo=mPiece(EPARCIMDetail,"^",20);
  var ilimitstr=mPiece(EPARCIMDetail,"^",21);
  var ioutpriorreclocstr=mPiece(EPARCIMDetail,"^",22);
  var iallergy=mPiece(EPARCIMDetail,"^",23);

	self.focus();
	if (ireclocstr=="") {
    alert(idesc+t['NO_RECLOC']);
		return false;
  }
	
	/*
  var ConflictCheck=CheckConflict(icode);
	if (ConflictCheck==false) {
		return false;
	}

  var ConflictCheck=CheckDupOrderItemCat(OrderItemCatRowid);
	if (ConflictCheck==true) {
		alert(idesc+t['ItemCatRepeat']);
		return false;
	}
	*/	
	
	//过敏检查
	var AllergyCheck=CheckItemAllergy(iallergy);
	if (AllergyCheck==false) {return false;}

  var InsurCheck=CheckItemInsurLimit(iinsurinfo);
	if (InsurCheck==false) {return false;}
	  
  var OrderPHForm=mPiece(iformstr,String.fromCharCode(1),0);
  var OrderConFac=mPiece(iformstr,String.fromCharCode(1),2);
  var OrderDrugFormRowid=mPiece(iformstr,String.fromCharCode(1),1);
  var OrderPoisonCode=mPiece(iformstr,String.fromCharCode(1),3);
	
	/*
  if (OrderType=="R"){
    var ARCIMDetail=OrderPHPrescType+"^"+OrderPHForm+"^"+OrderPoisonCode;
  	var PrescCheck=CheckPrescItemAndCount(idesc,icode,ARCIMDetail);
		if (PrescCheck==false){return false;}

	}else{  //非药物医嘱也要判断重复
    var PrescCheck=CheckDupOrderItem(icode);
    if (PrescCheck==true){
      var PrescCheck=confirm((idesc+t['SAME_ORDERITEM']),true);
			if (PrescCheck==false){return false;}
    }
  }
	*/

  var OrderPackQty=mPiece(ipackqtystr,String.fromCharCode(1),0);
  var OrderPackUOM=mPiece(ipackqtystr,String.fromCharCode(1),1);
  var OrderPackUOMRowid=mPiece(ipackqtystr,String.fromCharCode(1),2);
  var OrderFreq=mPiece(ifrequencestr,String.fromCharCode(1),0);
  var OrderFreqRowid=mPiece(ifrequencestr,String.fromCharCode(1),1);
  var OrderFreqFactor=mPiece(ifrequencestr,String.fromCharCode(1),2);
  var OrderFreqInterval=mPiece(ifrequencestr,String.fromCharCode(1),3);
  var OrderInstr=mPiece(iinstructionstr,String.fromCharCode(1),0);
  var OrderInstrRowid=mPiece(iinstructionstr,String.fromCharCode(1),1);
  var OrderDur=mPiece(idurationstr,String.fromCharCode(1),0);
  var OrderDurRowid=mPiece(idurationstr,String.fromCharCode(1),1);
  var OrderDurFactor=mPiece(idurationstr,String.fromCharCode(1),2);
  var OrderDefPriorRowid= mPiece(idefpriorstr,String.fromCharCode(1),1); 
  var OrderDefPrior=mPiece(idefpriorstr,String.fromCharCode(1),0); 
  var Price=mPiece(iretPrice,String.fromCharCode(1),0)
  var DiscPrice=mPiece(iretPrice,String.fromCharCode(1),1)
  var InsPrice=mPiece(iretPrice,String.fromCharCode(1),2)
  var PatPrice=mPiece(iretPrice,String.fromCharCode(1),3)
  var OrderMaxDurFactor=mPiece(ilimitstr,String.fromCharCode(1),0);
  var OrderMaxQty=mPiece(ilimitstr,String.fromCharCode(1),1);
  var OrderAlertStockQty=mPiece(ilimitstr,String.fromCharCode(1),2);
  var OrderMsg=mPiece(iordermsg,String.fromCharCode(1),0);
  var OrderFile1=mPiece(iordermsg,String.fromCharCode(1),1);
  var OrderFile2=mPiece(iordermsg,String.fromCharCode(1),2);
  var OrderFile3=mPiece(iordermsg,String.fromCharCode(1),3);
  var OrderARCOSRowid="";
  
	if (Price==0){
		var ret=confirm(idesc+t['NO_PRICE']);
		if (ret==false) return false;
	}

   //从医嘱套里传入的参数
  if (Para!=""){
  	//alert(Para);
    var ispecdoseqtystr=mPiece(Para,"^",0);
    var ispecfrequencestr=mPiece(Para,"^",1);
    var ispecinstructionstr=mPiece(Para,"^",2);
    var ispecdurationstr=mPiece(Para,"^",3);
    var ispecpackqtystr=mPiece(Para,"^",4);
    var ispecpriorstr=mPiece(Para,"^",5);
    var ispecordersetstr=mPiece(Para,"^",6);
  	var SpecOrderDoseQty=mPiece(ispecdoseqtystr,String.fromCharCode(1),0);
  	var SpecOrderDoseUOM=mPiece(ispecdoseqtystr,String.fromCharCode(1),1);
  	var SpecOrderDoseUOMRowid=mPiece(ispecdoseqtystr,String.fromCharCode(1),2);
    var SpecOrderFreq=mPiece(ispecfrequencestr,String.fromCharCode(1),0);
    var SpecOrderFreqRowid=mPiece(ispecfrequencestr,String.fromCharCode(1),1);
    var SpecOrderFreqFactor=mPiece(ispecfrequencestr,String.fromCharCode(1),2);
    var SpecOrderFreqInterval=mPiece(ispecfrequencestr,String.fromCharCode(1),3);
  	var SpecOrderInstr=mPiece(ispecinstructionstr,String.fromCharCode(1),0);
  	var SpecOrderInstrRowid=mPiece(ispecinstructionstr,String.fromCharCode(1),1);
  	var SpecOrderDur=mPiece(ispecdurationstr,String.fromCharCode(1),0);
  	var SpecOrderDurRowid=mPiece(ispecdurationstr,String.fromCharCode(1),1);
  	var SpecOrderDurFactor=mPiece(ispecdurationstr,String.fromCharCode(1),2);
	  var SpecOrderPackQty=mPiece(ispecpackqtystr,String.fromCharCode(1),0);
	  var SpecOrderPackUOM=mPiece(ispecpackqtystr,String.fromCharCode(1),1);
	  var SpecOrderPackUOMRowid=mPiece(ispecpackqtystr,String.fromCharCode(1),2);
	  var SpecOrderPrior=mPiece(ispecpriorstr,String.fromCharCode(1),0);
	  var SpecOrderPriorRowid=mPiece(ispecpriorstr,String.fromCharCode(1),1);
	  OrderFreq=SpecOrderFreq;
    OrderFreqRowid=SpecOrderFreqRowid;
    OrderFreqFactor=SpecOrderFreqFactor;
    OrderFreqInterval=SpecOrderFreqInterval;
  	OrderInstr=SpecOrderInstr;
  	OrderInstrRowid=SpecOrderInstrRowid;
  	OrderDur=SpecOrderDur;
  	OrderDurRowid=SpecOrderDurRowid;
  	OrderDurFactor=SpecOrderDurFactor;
  	OrderPackQty=SpecOrderPackQty;
  	OrderARCOSRowid=ispecordersetstr;
  }
  
  if (FocusRowIndex>1){
  	var PreRow=GetRow(TabName,FocusRowIndex-1);
  	OrderFreq=GetColumnData(TabName,"OrderFreq",PreRow);
  	OrderFreqRowid=GetColumnData(TabName,"OrderFreqRowid",PreRow);
  	OrderFreqFactor=GetColumnData(TabName,"OrderFreqFactor",PreRow);
  	OrderFreqInterval=GetColumnData(TabName,"OrderFreqInterval",PreRow);
  	OrderInstr=GetColumnData(TabName,"OrderInstr",PreRow);
  	OrderInstrRowid=GetColumnData(TabName,"OrderInstrRowid",PreRow);
	} 
  //OrderPriorRowid=GetColumnData(TabName,"OrderPriorRowid",Row);
  //if (OrderPriorRowid=="") OrderPriorRowid=OrderDefPriorRowid;
  OrderPriorRowid=OrderDefPriorRowid;
  
  var OrderBaseQty=1;
	var Qty=1;	
  
  //因为出院带药有可能指定接收科室?所以会存在两个接收科室串
  //当就诊类型为住院.出院带院接收科室有定义值.医嘱为药品时将CurrentRecLocStr置上供后面程序使用?
	if ((OrderPriorRowid==OutOrderPriorRowid)&&(ioutpriorreclocstr!="")&&(PAAdmType=="I")&&((OrderType=="R"))){
		var CurrentRecLocStr=ioutpriorreclocstr;
	}else{
		var CurrentRecLocStr=ireclocstr;
	}
	
	//如果为非库存项,将不会进入这个判断
	if (InciRowid!=""){
		var BaseDoseQty=1;		
		//if (OrderPackQty!="") {
		//	Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
		//}else{

	 	  var DefaultDoseQty="";
	 	  var DefaultDoseUOMRowid="";
		  if (Para!=""){
		  	DefaultDoseQty=SpecOrderDoseQty;
		  	DefaultDoseUOMRowid=SpecOrderDoseUOMRowid;
		  }else{
		 	  if (idoseqtystr!=""){
	        var ArrData=idoseqtystr.split(String.fromCharCode(2));
	        if (ArrData.length>0){
	       	  var ArrData1=ArrData[0].split(String.fromCharCode(1));
          	var DefaultDoseQty=ArrData1[0];
	          var DefaultDoseUOMRowid=ArrData1[2];
	        }
	      }
	    }
			if (DefaultDoseUOMRowid!=""){
				//alert("DrugFormRowid:"+OrderDrugFormRowid+"  DefaultDoseUOMRowid: "+DefaultDoseUOMRowid+"   DefaultDoseQty "+DefaultDoseQty);
				OrderBaseQty=cspRunServerMethod(CalDoseMethod,DefaultDoseUOMRowid,OrderDrugFormRowid,DefaultDoseQty);
				if (OrderBaseQty=="") OrderBaseQty=1;
			  //alert("OrderBaseQty:"+OrderBaseQty);
			}
			var dur=1;
			var OrderMultiDate=DHCC_GetElementData(FocusGroupId+"MultiDate");
			if (ChangeFlag==1) OrderMultiDate=GetFutureMultiDateStr(FocusGroupId);
			
			if (OrderMultiDate!=""){
				var DateArr=OrderMultiDate.split(",");
				var dur=DateArr.length;
			}

			//alert(OrderFreqFactor+"^"+OrderConFac+"^"+OrderBaseQty);
			Qty=parseFloat(OrderFreqFactor)*parseFloat(dur)*parseFloat(OrderBaseQty);
			OrderPackQty=parseFloat(Qty)/parseFloat(OrderConFac)
			OrderPackQty=OrderPackQty.toFixed(4);
			OrderPackQty=Math.ceil(OrderPackQty);
			
		//}
		//alert("Qty:"+Qty);
		if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
			var CheckQty=1;
			if (PAAdmType!="I") {CheckQty=OrderConFac}
  		var ret=CheckStockEnough(idesc,icode,CheckQty,CurrentRecLocStr);
  		//返回库存医嘱的可用库存的科室,
  		if (ret=="") {
  			return false
  		}else{
  			OrderRecDepRowid=mPiece(ret,String.fromCharCode(1),0);
  		}
  	}else{
  		OrderRecDepRowid="";
  	}
	}
	
	Price=parseFloat(Price).toFixed(4);
	if (PAAdmType!="I"){
	  var Sum=parseFloat(OrderPackQty)*parseFloat(Price);
	  Sum=Sum.toFixed(2);
	}else{
		//自备药医嘱不计入总金额
		var Sum=0;
		if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
			Sum=(parseFloat(Price)/parseFloat(OrderConFac))*parseFloat(Qty);
		}
		Sum=Sum.toFixed(4);		
	}
	//自备药医嘱和无费用医嘱不参与费用控制
	if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(Price!=0)){
		/*
		var PrescCheck=CheckPrescriptSum(Sum,icode);
		if (PrescCheck==false) return false;
		*/
	}
	
	SetColumnData(TabName,"OrderPrior",Row,OrderPriorRowid);
	SetColumnData(TabName,"OrderPriorRowid",Row,OrderPriorRowid);
	
	SetColumnList(TabName,"OrderDoseUOM",Row,idoseqtystr)
	//把前面的得到可用接收科室串用来置接收科室List
  SetColumnList(TabName,"OrderRecDep",Row,CurrentRecLocStr)
  //SetColumnList(TabName,"OrderBillType",Row,BillTypeStr);
	
	var BillType="",BillTypeRowId="";
	var BillTypeStr=cspRunServerMethod(GetDefaultBillTypeMethod,EpisodeID,icode);
	var BillTypeNum=mPiece(BillTypeStr,"^",2);
  if ((OrderMsg=="")||(BillTypeNum==1)) {
	  var BillTypeRowId=mPiece(BillTypeStr,"^",0);
	  var BillType=mPiece(BillTypeStr,"^",1);
  }
	SetColumnData(TabName,"OrderBillType",Row,BillType);
	SetColumnData(TabName,"OrderBillTypeRowId",Row,BillTypeRowId);
  if (Para!=""){
		 SetColumnData(TabName,"OrderDoseQty",Row,SpecOrderDoseQty);
		 SetColumnData(TabName,"OrderDoseUOM",Row,SpecOrderDoseUOMRowid);	       
		 SetColumnData(TabName,"OrderDoseUOMRowid",Row,SpecOrderDoseUOMRowid);
  }
  /*
  var CellObj=document.getElementById("OrderDoseQtyz"+Row);
	if (CellObj){
		CellObj.className="clsInvalid";
	}	
	*/
	//设定前面给定的有库存接受科室
	if (OrderRecDepRowid!="") {
		SetColumnData(TabName,"OrderRecDep",Row,OrderRecDepRowid);
		SetColumnData(TabName,"OrderRecDepRowid",Row,OrderRecDepRowid);
	}

 	SetColumnData(TabName,"OrderFreq",Row,OrderFreq);
	SetColumnData(TabName,"OrderFreqRowid",Row,OrderFreqRowid);
	SetColumnData(TabName,"OrderInstr",Row,OrderInstr);
	SetColumnData(TabName,"OrderInstrRowid",Row,OrderInstrRowid);
	SetColumnData(TabName,"OrderDur",Row,OrderDur);
	SetColumnData(TabName,"OrderDurRowid",Row,OrderDurRowid);
  SetColumnData(TabName,"OrderFreqFactor",Row,OrderFreqFactor);
  SetColumnData(TabName,"OrderFreqInterval",Row,OrderFreqInterval);  
  SetColumnData(TabName,"OrderDurFactor",Row,OrderDurFactor);  
  //var dur=GetColumnData(TabName,"OrderDurFactor",Row);
  //alert("idurationstr="+idurationstr+"    OrderDurFactor="+OrderDurFactor+"    OrderDurRowid="+OrderDurRowid+"    OrderDur="+OrderDur+"    dur="+dur+"           ");
  SetColumnData(TabName,"OrderConFac",Row,OrderConFac);  
	SetColumnData(TabName,"OrderPHForm",Row,OrderPHForm);
	SetColumnData(TabName,"OrderPHPrescType",Row,OrderPHPrescType);	
  SetColumnData(TabName,"OrderARCIMRowid",Row,icode);
  SetColumnData(TabName,"OrderDrugFormRowid",Row,OrderDrugFormRowid);	
  SetColumnData(TabName,"OrderName",Row,idesc);
  SetColumnData(TabName,"OrderPackQty",Row,OrderPackQty);
	SetColumnData(TabName,"OrderPackUOM",Row,OrderPackUOM);
  SetColumnData(TabName,"OrderPackUOMRowid",Row,OrderPackUOMRowid);
  SetColumnData(TabName,"OrderPrice",Row,Price);
	SetColumnData(TabName,"OrderSum",Row,Sum);
  SetColumnData(TabName,"OrderType",Row,OrderType);
  SetColumnData(TabName,"OrderBaseQty",Row,OrderBaseQty);  
  SetColumnData(TabName,"OrderARCOSRowid",Row,OrderARCOSRowid ); 
  SetColumnData(TabName,"OrderMaxDurFactor",Row,OrderMaxDurFactor); 
  SetColumnData(TabName,"OrderMaxQty",Row,OrderMaxQty); 
  SetColumnData(TabName,"OrderBaseQtySum",Row,Qty);
  SetColumnData(TabName,"OrderAlertStockQty",Row,OrderAlertStockQty);  
  SetColumnData(TabName,"OrderPoisonCode",Row,OrderPoisonCode); 
  SetColumnData(TabName,"OrderMsg",Row,OrderMsg); 
  
  var needskintest=mPiece(iskintest,String.fromCharCode(1),0);
  var skintestyy=mPiece(iskintest,String.fromCharCode(1),1);
  //住院开整包装标志
  var IPNeedBillQty=mPiece(iskintest,String.fromCharCode(1),2);
  //是否紧急标志可用
  var EmergencyFlag=mPiece(iskintest,String.fromCharCode(1),3);
  if (needskintest=="Y")  SetColumnData(TabName,"OrderSkinTest",Row,true);
  if (InsurCheck==false) SetColumnData(TabName,"OrderCoverMainIns",Row,false);

  //以String.fromCharCode(1)为分隔符
  var OrderHiddenPara=skintestyy+String.fromCharCode(1)+IPNeedBillQty+String.fromCharCode(1)+OrderItemCatRowid;
  SetColumnData(TabName,"OrderHiddenPara",Row,OrderHiddenPara);

	/*
	SetRowStyleClass(FocusRowIndex,OrderPriorRowid,"");
  SetScreenSum();
	*/
	SetFocusColumn(TabName,"OrderDoseQty",Row);
	return true;
}

function CheckItemAllergy(iallergy){
	var TempPlist=iallergy.split(String.fromCharCode(1));
	var allergycode=TempPlist[0];
	var allergymsg=TempPlist[1];
	if (allergycode=="01"){
		alert(t['Have_Allergy']);
		return false;
	}
}
function CheckItemInsurLimit(iinsurinfo){
	var TempPlist=iinsurinfo.split(String.fromCharCode(1));
	var InsurAdmFlag=TempPlist[0];
	var DiagnosCatArcimPass=TempPlist[1];
	var PreOrderDate=TempPlist[2];
	var IsADMInsTypeDCArcim=TempPlist[3];
	if ((InsurAdmFlag=="1")&&(PAAdmType=="I")){
		alert(t['InsurLimitOP']);
		return true;
	}
	if ((InsurAdmFlag=="2")&&(PAAdmType=="I")){
		alert(t['InsurLimit']);
		return true;
	}
	if ((DiagnosCatArcimPass=="0")&&(PAAdmType!="I")){
		alert(t['DiagnosCatArcimAllow']);
		return false;
	}	

	if ((PreOrderDate!="")&&(PAAdmType=="O")){
		alert(PreOrderDate+t['InPreOrderDuration']);
	}
	
	if (IsADMInsTypeDCArcim=="1"){
		alert(t['IsADMInsTypeDCArcim']);
		return false;
	}
	return true;
}

function CheckStockEnough(OrderName,OrderARCIMRowid,OrderPackQty,str){
	if (OrderPackQty==""){return "-1"}
  var ArrData=str.split(String.fromCharCode(2));
	if (ArrData.length==1){
		var ArrData1=ArrData[0].split(String.fromCharCode(1));
		var OrderRecDepRowid=ArrData1[0];
		var OrderRecDepDesc=ArrData1[1];

		var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,OrderRecDepRowid);
		if (Check=='0') {
			RtnOrderNoEnough=confirm(OrderName+t['Alert_QTY_NOTENOUGH']);
			if(RtnOrderNoEnough==false) return "";    
			else return ArrData[0];
		}else{
			return ArrData[0];
		}
	}else{
 	  var DefaultRecLocRowid="";
 	  var DefaultRecLocDesc="";
		for (var i=0;i<ArrData.length;i++) {
			var ArrData1=ArrData[i].split(String.fromCharCode(1));
			if (ArrData1[2]=="Y") {
				DefaultRecLocRowid=ArrData1[0];
				DefaultRecLocDesc=ArrData1[1];
			}
		}

		if (DefaultRecLocRowid!=""){
			var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,DefaultRecLocRowid);
			if (Check!='0'){
				return DefaultRecLocRowid+String.fromCharCode(1)+DefaultRecLocDesc;
			}
		}

		for (var i=0;i<ArrData.length;i++) {
			var ArrData1=ArrData[i].split(String.fromCharCode(1));
			if (ArrData1[2]!="Y") {
				var OrderRecDepRowid=ArrData1[0];
				var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,OrderRecDepRowid);
				if (Check!='0') {
					alert(OrderName+t['Change_Stock_Recloc']);
					return ArrData[i];
				}
			}
		}
		alert(OrderName+t['QTY_NOTENOUGH']);
		return ""		
	}
}

function GroupItemSelectRow(evt){
	var evtSrcElm=websys_getSrcElement(evt);
	var rowObj=getRow(evtSrcElm);
	FocusRowIndex=rowObj.rowIndex
	var objtbl=GetEventTable(evt);
	FocusGroupId=objtbl.id
}

function StopGroupItem(GroupRow) {
	var StopGroupItemObj=document.getElementById("tGroup"+GroupRow+"StopGroupItem");
	if (StopGroupItemObj.disabled==true){
		return;
	}
	var SelRowIndex=GetGroupRowIndex(e);
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	if(GroupRow!=FocusGroupIndex) {
		alert(t['No_SelectGroup']); 
		return;
	}

	tGroupId="tGroup"+GroupRow
	var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",FocusRowIndex);
	var OrderName=GetColumnData(tGroupId,"OrderName",FocusRowIndex);
	if ((SheetItemStatus=="S")||(SheetItemStatus=="R")) {
		alert(OrderName+"	"+t['No_NeedStop']);
		return;
	}
	var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",FocusRowIndex);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",FocusRowIndex);
	if ((OrderItemRowid!="")&&(OrderARCIMRowid!="")){
		SetColumnData(tGroupId,"SheetItemStatus",FocusRowIndex,"To Stop")
		var Row=GetRow(tGroupId,FocusRowIndex);
		SetRowColor(tGroupId,Row,"red");
	}	
}

function CancelStopGroupItem(GroupRow) {
	var CancelStopGroupItemObj=document.getElementById("tGroup"+GroupRow+"CancelStopGroupItem");
	if (CancelStopGroupItemObj.disabled==true){
		return;
	}
	var SelRowIndex=GetGroupRowIndex(e);
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	if(GroupRow!=FocusGroupIndex) {
		alert(t['No_SelectGroup']); 
		return;
	}
	
	tGroupId="tGroup"+GroupRow
	var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",FocusRowIndex);
	var OrderItemStopDate=GetColumnData(tGroupId,"OrderItemStopDate",FocusRowIndex);
	var OrderItemAddDate=GetColumnData(tGroupId,"OrderItemAddDate",FocusRowIndex);
	var OrderName=GetColumnData(tGroupId,"OrderName",FocusRowIndex);
	if (OrderItemStopDate!="") {
		alert(OrderName+"	"+t['CanNotStop']);
		return;
	}
	if (SheetItemStatus!="To Stop") {
		alert(OrderName+"	"+t['No_NeedCancelStop']);
		return;
	}
	var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",FocusRowIndex);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",FocusRowIndex);
	if ((OrderItemRowid!="")&&(OrderARCIMRowid!="")){
		SetColumnData(tGroupId,"SheetItemStatus",FocusRowIndex,"")
		//alert(OrderName+"	"+t['CancelStop_Succeed']);
		var Row=GetRow(tGroupId,FocusRowIndex);
		if (OrderItemAddDate==""){
			SetRowColor(tGroupId,Row,"");	
		}else{
			SetRowColor(tGroupId,Row,"green");
		}
		
	}	
}

function SetRowColor(GroupId,Row,color){
	document.getElementById(GroupId+"OrderSeqNoz"+Row).style.color=color;
	document.getElementById(GroupId+"OrderNamez"+Row).style.color=color;
	document.getElementById(GroupId+"OrderDoseQtyz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderDoseUOMz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderFreqz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderInstrz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderPricez"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderDepProcNotez"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderPackQtyz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderPackUOMz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderBillTypez"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderPrescz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderMsgz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderSumz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderRecDepz"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderItemStopDatez"+Row).style.color=color;;
	document.getElementById(GroupId+"OrderItemAddDatez"+Row).style.color=color;;
	var OrderItemBilled=document.getElementById(GroupId+'OrderItemBilled');		
	if (OrderItemBilled){
		document.getElementById(GroupId+"OrderItemBilledz"+Row).style.color=color;;
	}
}

function SetTableColor(){
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var GroupNo=GetGroupRow(objtbl,i);
			var grouptbl=GetCellObj('SheetGroup',GroupNo);
			var f=websys_getChildElements(grouptbl);
			//alert("f.length==  "+f.length)
			for (var j=0;j<f.length;j++) {
				if (f[j].tagName=="TABLE") {
					if (f[j].id.substring(0,7)=="tGroupM"){
						var SubObjId=f[j].id.split("tGroupM");
						var GroupRow=SubObjId[1];
					}
				}
			}

			var tGroupId="tGroup"+GroupRow;
			var itemtbl=document.getElementById(tGroupId);
			var itemrows=itemtbl.rows.length;
			for (var j=1; j<itemrows; j++){
				var Row=GetRow(tGroupId,j);
				var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
				if ((SheetItemStatus=="S")||(SheetItemStatus=="R")) SetRowColor(tGroupId,Row,"red");
				if (SheetItemStatus=="A") SetRowColor(tGroupId,Row,"green");
			}
			
		}
}

function DeleteGroupItem(GroupRow) {
	try {
		var DeleteGroupItemObj=document.getElementById("tGroup"+GroupRow+"DeleteGroupItem");
		if (DeleteGroupItemObj.disabled==true){
			return;
		}
		var Ret=CanDeleteRow(GroupRow);
		if (Ret==false) return;
		var objtbl=document.getElementById("tGroup"+GroupRow);
		var rows=objtbl.rows.length;
		if (rows>2){
			objtbl.deleteRow(FocusRowIndex);
			
		}else{
			ClearRow("tGroup"+GroupRow,1);
			var Row=GetRow("tGroup"+GroupRow,1);
			websys_setfocus("tGroup"+GroupRow+"OrderNamez"+Row);
		}	
	  SetScreenSum()
	} catch(e) {};
}

function CanDeleteRow(GroupRow){
	if(GroupRow!=FocusGroupIndex) {
		alert(t['No_SelectGroup']); 
		return false;
	}
	var SheetRowId=DHCC_GetElementData('SheetRowId');
	var obj=document.getElementById('ModifyFlag');
	if (obj) ModifyFlag=obj.value
	var obj=document.getElementById('ChangeFlag');
	if (obj) ChangeFlag=obj.value
	if (SheetRowId=="") return true;
	if (ModifyFlag!="") return true;
	if (ChangeFlag!="") {
		var OrderItemRowid=GetColumnData("tGroup"+GroupRow,"OrderItemRowid",FocusRowIndex);
		if (OrderItemRowid=="") return true;
	}
	return false;	
}

function AddGroupItem(GroupRow){
	try {
		var AddGroupItemObj=document.getElementById("tGroup"+GroupRow+"AddGroupItem");
		if (AddGroupItemObj.disabled==true){
			return;
		}	
		var objtbl=document.getElementById("tGroup"+GroupRow);
		var ret=CanAddRow(objtbl);
		if (ret){
			var obj=document.getElementById('ChangeFlag');
			if (obj) ChangeFlag=obj.value;
			if (ChangeFlag==""){
				AddRowToList(objtbl);
			}else{
				AddRowToReadOnlyList(objtbl);
			}    
	  }
    //可以控制屏幕不跳动
    SetScreenSum();
    return false;
	} catch(e) {};
}

function CanAddRow(objtbl){
	var rows=objtbl.rows.length;
	if (rows==1) return false;
	var Row=GetRow(objtbl.id,rows-1);
	var OrderItemRowid=GetColumnData(objtbl.id,"OrderItemRowid",Row);
	var OrderARCIMRowid=GetColumnData(objtbl.id,"OrderARCIMRowid",Row);
	if (OrderARCIMRowid==""){	
		SetFocusColumn(objtbl.id,"OrderName",Row);
		FocusRowIndex=rows-1;
		return false;
	}
	return true;
}

function AddRowToList(objtbl) {
	var rows=objtbl.rows.length;
	var objlastrow=objtbl.rows[rows-1];
	//make sure objtbl is the tbody element,
	//之所以要走tk_getTBody?是因为TBody不包括THead,而且TBody只有appendChild,但只用通过rowobj才能取得TBody
	//tUDHCOEOrder_List_Custom是包括THeader和Tbody
	//tUDHCOEOrder_List_Custom.rows和TBody.rows是不同的?后者一般比前者少1
	objtbody=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
	    //rowitems其实是element的集合,每个element的ParentElement就是Tabelobj.RowObj.Cell对象
	    //将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
			/*
			if (arrId[0]=="OrderPrior"){
				var obj=websys_getParentElement(rowitems[j]); 
				var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"width:" + obj.style.width +"\" value=\"\">";
        obj.innerHTML=str;
			} 
			*/
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	objnewrow=objtbody.appendChild(objnewrow);

	//默认置上前一条的医嘱类型	
	if (objtbl.rows.length>2) {
		var PreRow=GetRow(objtbl.id,objtbl.rows.length-2);
		var PreOrderPriorRowid=GetColumnData(objtbl.id,"OrderPriorRowid",PreRow);
		var PreOrderSeqNo=GetColumnData(objtbl.id,"OrderSeqNo",PreRow);
		//alert("PreOrderPriorRowid="+PreOrderPriorRowid+"      PreOrderSeqNo="+PreOrderSeqNo+"      PreRow="+PreRow);
		//如果是门诊开医嘱?不要把上一条记录医嘱类型带下来
		//if (PAAdmType!="I"){
		//   PreOrderPriorRowid=DefaultOrderPriorRowid;
		//}
	}

	FocusRowIndex=objnewrow.rowIndex;
	var Row=GetRow(objtbl.id,objnewrow.rowIndex);
	if (PreOrderPriorRowid!=""){
		SetColumnData(objtbl.id,"OrderPrior",Row,PreOrderPriorRowid);
		SetColumnData(objtbl.id,"OrderPriorRowid",Row,PreOrderPriorRowid);
	}

	//SetColumnData(objtbl.id,"OrderSeqNo",Row,parseInt(PreOrderSeqNo)+1);
	SetColumnData(objtbl.id,"OrderSeqNo",Row,parseInt(FocusRowIndex));
	websys_setfocus(objtbl.id+"OrderNamez"+Row);

	//alert("add:"+FocusRowIndex);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function AddRowToReadOnlyList(objtbl) {
	// 在不可编辑的界面上加添加药品?即加一行
	var rows=objtbl.rows.length;
	var objlastrow=objtbl.rows[rows-1];
	objtbody=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	objnewrow=objtbody.appendChild(objnewrow);
	ChangeRowStyle(objtbl.id,objnewrow,1,true);
	//默认置上前一条的医嘱类型	
	if (objtbl.rows.length>2) {
		var PreRow=GetRow(objtbl.id,objtbl.rows.length-2);
		var PreOrderPriorRowid=GetColumnData(objtbl.id,"OrderPriorRowid",PreRow);
		var PreOrderSeqNo=GetColumnData(objtbl.id,"OrderSeqNo",PreRow);
		//如果是门诊开医嘱?不要把上一条记录医嘱类型带下来
		//if (PAAdmType!="I"){
		//   PreOrderPriorRowid=DefaultOrderPriorRowid;
		//}
	}

	FocusRowIndex=objnewrow.rowIndex;
	var Row=GetRow(objtbl.id,objnewrow.rowIndex);
	if (PreOrderPriorRowid!=""){
		SetColumnData(objtbl.id,"OrderPrior",Row,PreOrderPriorRowid);
		SetColumnData(objtbl.id,"OrderPriorRowid",Row,PreOrderPriorRowid);
	}

	//SetColumnData(objtbl.id,"OrderSeqNo",Row,parseInt(PreOrderSeqNo)+1);
	SetColumnData(objtbl.id,"OrderSeqNo",Row,parseInt(FocusRowIndex));
	websys_setfocus(objtbl.id+"OrderNamez"+Row);

	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function ChangeRowStyle(GroupId,RowObj,EnablePackQty,EnableDuration,OrdMsg){
	for (var j=0;j<RowObj.cells.length;j++) {
      if (!RowObj.cells[j].firstChild) {continue} 
		  var Id=RowObj.cells[j].firstChild.id;
			var arrId=Id.split("z");
		  var objindex=arrId[1];
		  var objwidth=RowObj.cells[j].style.width;
		  var objheight=RowObj.cells[j].style.height;
		  var IMGId="ldi"+Id;
      //alert("type:"+RowObj.cells[j].firstChild.type)
      //var objtype=RowObj.cells[j].firstChild.type;
      //if (objtype) {continue}
		
			//alert(RowObj.cells[j].style.height);
			/*
			1.RowObj.cells[i]本身是个对象,本身有Style属性,里面可以包含多个element(HIDDEN TableItem就全放在了一个Cell中)
			2.cells[j].firstChild是Cell里的第一个element,如果为label的话就没有type属性
			3.将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
      4.只有列不为Display only?不一定会有Style属性(可以参见网页源码),所以最好只将Display Only的列变为可编辑时候
        对innerHTML属性进行重新定义,否则容易造成列自动变为一个默认长度
      */
			if (arrId[0]==GroupId+"OrderPrior"){
          if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  //cells[j].className="DentalSel";
				 //alert(owObj.cells[j].className);
				  //alert(RowObj.cells[j].innerHTML);
				  //alert(RowObj.cells[j].style.height);
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderPriorchangehandler()\">";
          //alert(str);
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=OrderPriorStr.split("^");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[0]);
		         }
		         //obj.onchange=PrescList_Change;
		      }
          //alert(RowObj.cells[j].innerHTML);
			}
			if (arrId[0]==GroupId+"OrderName"){
				  var OrderMsg="";
					if (arguments.length==4) OrderMsg=arguments[3];
				  objwidth=AdjustWidth(objwidth);
				  //\""+objindex+"\"
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" title=\""+OrderMsg+"\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"xItem_lookuphandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"xItem_lookuphandler()\">";
          //alert(str);
          RowObj.cells[j].innerHTML=str;
          /*也可以采用下面的方式定义事件
					var obj=document.getElementById(Id);
					if (obj) obj.onkeydown=Item_lookuphandler;
					var obj=document.getElementById(IMGId);
					if (obj) obj.onclick=Item_lookuphandler;
					*/
			}
			if (arrId[0]==GroupId+"OrderDoseQty"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderDoseQtychangehandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}

			if (arrId[0]==GroupId+"OrderDoseUOM"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderDoseUOMchangehandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]==GroupId+"OrderFreq"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCFRDesc_lookuphandler()\" onchange=\"FrequencyChangeHandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCFRDesc_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderInstr"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCINDesc_lookuphandler()\" onchange=\"InstrChangeHandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCINDesc_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderDur"){
					objwidth=AdjustWidth(objwidth);
					//住院的草药还需要录入疗程?开即刻医嘱
					//if ((PAAdmType!="I")||((OrderPHPrescType=="3")&&(PAAdmType=="I"))){
					if (EnableDuration){
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCDUDesc_lookuphandler()\" onchange=\"DurationChangeHandler()\">";
						str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCDUDesc_lookuphandler()\">";
          }else{
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderPackQty"){
				  if (EnablePackQty==1) {
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">";
          }else{
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderRecDep"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderRecDepchangehandler()\" onkeydown=\"OrderRecDepkeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]==GroupId+"OrderMasterSeqNo"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderSeqNochangehandler()\" onkeydown=\"OrderSeqNokeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderDepProcNote"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderStartDate"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onkeydown=\"OEORISttDat_lookuphandler()\" onchange=\"OEORISttDat_changehandler()\" value=\"\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OEORISttDat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderStartTime"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OEORISttTim_changehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderEndDate"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onkeydown=\"OEORIEndDat_lookuphandler()\" onchange=\"OEORIEndDat_changehandler()\" value=\"\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OEORIEndDat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderEndTime"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OEORIEndTim_changehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderPrice"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderAutoCalculate"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" checked=true>";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderPhSpecInstr"){
				  if (EnablePackQty==1) {
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
            RowObj.cells[j].innerHTML=str;
          }else{
					  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
						var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\">";
	          RowObj.cells[j].innerHTML=str;
	          obj=RowObj.cells[j].firstChild;
	          if (obj){
							 var PhSpecInstrArray=new Array();
							 var PhSpecInstrArray=PhSpecInstrList.split("^");
							 obj.options[obj.length] = new Option("","");
							 for (var i=0;i<PhSpecInstrArray.length;i++) {
									var TempArray=new Array();
									var TempArray=PhSpecInstrArray[i].split(String.fromCharCode(1));
									obj.options[obj.length] = new Option(TempArray[1],TempArray[1]);
							 }
			      }
          }
			}			
			if (arrId[0]==GroupId+"OrderAction"){
          if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderActionchangehandler()\">";
          //alert(str);
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=OrderActionStr.split("^");
		         obj.options[obj.length] = new Option("","");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[0]);
		         }
		      }
			}
			if (arrId[0]==GroupId+"OrderLabSpec"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}							
			if (arrId[0]==GroupId+"OrderSkinTest"){
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"OrderSkinTestChangehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderMultiDate"){
					objwidth=AdjustWidth(objwidth);
					var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onclick=\"OrderMultiDateClickhandler()\"></A>";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OrderMultiDateClickhandler()\">";
					//RowObj.cells[j].firstChild.href+"\"
          //<A id="OrderMultiDatez1" HREF="websys.csp?TEVENT=t50151iOrderSelectMultiDate&TPAGID=715717&TWKFL=50002&TWKFLI=1&TRELOADID=130361" style="WIDTH: 51px; HEIGHT: 22px" tabIndex="999"><img SRC="../images/websys/lookupdate.gif" BORDER="0"></A>
          RowObj.cells[j].innerHTML=str;
			}							
			if (arrId[0]==GroupId+"OrderBillType"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"BillType_lookuphandler()\" onchange=\"BillTypeChangeHandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"BillType_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"OrderPresc"){
					var str="<input type=checkbox  id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;  HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]==GroupId+"SolventFlag"){
					var VenousFillingFlag=DHCC_GetElementData(GroupId+"VenousFillingFlag");
					if (VenousFillingFlag==true){
						var str="<input type=checkbox  id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;  HEIGHT:" + objheight +"\" value=\"\">";
						RowObj.cells[j].innerHTML=str;
					}
			}
			//innerHTMLs=innerHTMLs+'<TD  STYLE="WIDTH: 30px; HEIGHT: 22px"><input id="'+GroupId+'SolventFlagz'+j+'" name="'+GroupId+'SolventFlagz'+j+'" Style="WIDTH: 30px; HEIGHT: 22px" disabled type="checkbox"></input></TD>';
			
	}
}

//如果有图标和元素在同一列里?要调整元素的宽度
function AdjustWidth(objwidth){
  if (objwidth!=""){
  	 var objwidtharr=objwidth.split("px")
  	 var objwidthnum=objwidtharr[0]-25;
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function DelBlankGroup(){
	// 删除空白组
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	var GroupNo=GetGroupRow(objtbl,rows-1);
	var grouptbl=GetCellObj('SheetGroup',GroupNo);
	var f=websys_getChildElements(grouptbl);
	for (var j=0;j<f.length;j++) {
		if (f[j].tagName=="TABLE") {
			if (f[j].id.substring(0,7)=="tGroupM"){
				var SubObjId=f[j].id.split("tGroupM");
				var GroupRow=SubObjId[1];
			}
		}
	}
	var tGroupId="tGroup"+GroupRow;
	var Row=GetRow(tGroupId,1);
	var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
	if (OrderARCIMRowid=="") {
		var DelRow=rows-1;
		DeleteGroupByPara(DelRow);
	}
}

function DeleteGroupByPara(SelRowIndex) {
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	if (rows>2){
		objtbl.deleteRow(SelRowIndex);
	}else{
		var Row=GetGroupRow(objtbl,1);
		AddGroupDIVToCell(Row);
		websys_setfocus("tGroup"+Row+"OrderNamez1");
	}
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	SetScreenSum()
  return false;
}

function CheckBeforeUpdate(){
	DelBlankGroup();
	try{
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var GroupNo=GetGroupRow(objtbl,i);
			var grouptbl=GetCellObj('SheetGroup',GroupNo);
			var f=websys_getChildElements(grouptbl);
			for (var j=0;j<f.length;j++) {
				if (f[j].tagName=="TABLE") {
					if (f[j].id.substring(0,7)=="tGroupM"){
						var SubObjId=f[j].id.split("tGroupM");
						var GroupRow=SubObjId[1];
					}
				}
			}
			var tGroupId="tGroup"+GroupRow;	
			var ChangeMultiDateObj=document.getElementById(tGroupId+'ChangeMultiDate');		
			if (ChangeMultiDateObj){
				var OrderMultiDate=DHCC_GetElementData(tGroupId+"ChangeMultiDate");
			}else{
				var OrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
			}
			if (OrderMultiDate==""){
				alert("第"+GroupRow+"组未选择化疗日期,"+t['ExeDateIsNull']);
				return false;
			}
			var VenousFillingFlag=DHCC_GetElementData(tGroupId+"VenousFillingFlag");
			var IncludeSolventFlag=false;
			var Row=GetRow(tGroupId,1);
			var OrderFreqRowidFirst=GetColumnData(tGroupId,"OrderFreqRowid",Row);
			var OrderInstrRowidFirst=GetColumnData(tGroupId,"OrderInstrRowid",Row);
			var itemtbl=document.getElementById(tGroupId);
			var itemrows=itemtbl.rows.length;
			for (var j=1; j<itemrows; j++){
				var Row=GetRow(tGroupId,j);
				var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
				var OrderName=GetColumnData(tGroupId,"OrderName",Row);
				var OrderType=GetColumnData(tGroupId,"OrderType",Row);
				var OrderRecDepRowid=GetColumnData(tGroupId,"OrderRecDepRowid",Row);
				var OrderFreqRowid=GetColumnData(tGroupId,"OrderFreqRowid",Row);
				var OrderFreq=GetColumnData(tGroupId,"OrderFreq",Row);
		    var OrderInstrRowid=GetColumnData(tGroupId,"OrderInstrRowid",Row);
		    var OrderInstr=GetColumnData(tGroupId,"OrderInstr",Row);
		    var OrderDoseQty=GetColumnData(tGroupId,"OrderDoseQty",Row);	
		    var OrderDoseUOMRowid=GetColumnData(tGroupId,"OrderDoseUOMRowid",Row);
		    var OrderDoseUOM=GetColumnData(tGroupId,"OrderDoseUOM",Row);
		    var OrderPackQty=GetColumnData(tGroupId,"OrderPackQty",Row);
		    var OrderPrice=GetColumnData(tGroupId,"OrderPrice",Row);
		    var BillTypeRowid=GetColumnData(tGroupId,"OrderBillTypeRowid",Row);
		    var OrderFreqInterval=GetColumnData(tGroupId,"OrderFreqInterval",Row); 
		    var DisTimeFlag=cspRunServerMethod(CheckFreqDisTimeMethod,OrderFreqRowid);
				//if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){	
				if (OrderARCIMRowid!=""){	
					if (parseInt(OrderFreqInterval)>1){
						alert("第"+GroupRow+"组 "+OrderName+" 的频次为隔日频次,请重新选择频次");
						return false;
					}
					if (DisTimeFlag==0){
						alert("第"+GroupRow+"组 "+OrderName+" 的频次没有分发时间,请重新选择频次");	
						return false;
					}
			    if ((OrderDoseQty=='')||(parseFloat(OrderDoseQty)==0)) {
						alert("第"+GroupRow+"组 "+OrderName+t['NO_DoseQty']);
						SetFocusColumn(tGroupId,"OrderDoseQty",Row);
						FocusRowIndex=i;
						return false;
					}
					if ((OrderFreqRowid=='')||(OrderFreq=="")) {
						alert("第"+GroupRow+"组 "+OrderName+t['NO_Frequence']);
						SetFocusColumn(tGroupId,"OrderFreq",Row);
						FocusRowIndex=i;
						return false;
					}
					if (((OrderDoseUOMRowid=='')||(OrderDoseUOM==""))) {
						alert("第"+GroupRow+"组 "+OrderName+t['NO_DoseUOM']);
						SetFocusColumn(tGroupId,"OrderDoseUOM",Row);
						FocusRowIndex=i;
						return false;
					}
					if ((OrderInstrRowid=='')||(OrderInstr=='')) {
						alert("第"+GroupRow+"组 "+OrderName+t['NO_Instr']);
						SetFocusColumn(tGroupId,"OrderInstr",Row);
						FocusRowIndex=i;
						return false;
					}				
					if ((OrderPackQty!="")&&(!isInteger(OrderPackQty))){
						alert("第"+GroupRow+"组 "+OrderName+t['Not_Number']);
						FocusRowIndex=i;
						SetFocusColumn(tGroupId,"OrderPackQty",Row);
						return false;
					}
					if (OrderPackQty=="") {OrderPackQty=0}
					if (parseFloat(OrderPackQty)==0){
						alert("第"+GroupRow+"组 "+OrderName+t['NO_PackQty']);
						FocusRowIndex=i;
						SetFocusColumn(tGroupId,"OrderPackQty",Row);
						return false;
					}
					if (ChangeFlag==1) {
						var ChangeMultiDateObj=document.getElementById(tGroupId+'ChangeMultiDate');
						if (ChangeMultiDateObj){
							var FutureMultiDate=GetFutureMultiDateStr(tGroupId);
							if (FutureMultiDate==""){
								alert("第"+GroupRow+"组 "+OrderName+"	"+t['NewAdd_ExeDateIsNull']);
								return false;
							}
						}	
					}
					if ((VenousFillingFlag==false)&&(OrderFreqRowid!=OrderFreqRowidFirst)){
						alert("第"+GroupRow+"组药品的频次不一致,请重新选择");
						return false;
					}
					if ((VenousFillingFlag==false)&&(OrderInstrRowid!=OrderInstrRowidFirst)){
						alert("第"+GroupRow+"组药品的用法不一致,请重新选择");
						return false;
					}
					var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
					if((SheetItemStatus=="To Stop")||(SheetItemStatus=="R")){
						SheetItemStatus="S";
					}
					if ((VenousFillingFlag==true)&&(IncludeSolventFlag==false)){
						var SolventFlag=GetColumnData(tGroupId,"SolventFlag",Row);
						if ((SolventFlag==true)&&(SheetItemStatus!="S")) IncludeSolventFlag=true;	
					}		
				}
				var OrderPresc=GetColumnData(tGroupId,"OrderPresc",Row);
  		  var OrderPresced=GetColumnData(tGroupId,"OrderPresced",Row);
  		  var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
  		  if ((OrderARCIMRowid!="")&&(OrderPresc)&&(OrderPresced==0)&&(SheetItemStatus!="S")&&(SheetItemStatus!="R")){
    		  var OrderBaseQty=GetColumnData(tGroupId,"OrderBaseQty",Row);
				  var OrderFreqFactor=GetColumnData(tGroupId,"OrderFreqFactor",Row);
				  var OrderConFac=GetColumnData(tGroupId,"OrderConFac",Row);
				  var OrderAlertStockQty=GetColumnData(tGroupId,"OrderAlertStockQty",Row);	
					var Qty=1;
					if (OrderBaseQty=="") {OrderBaseQty=1;}
					if (OrderFreqFactor==""){OrderFreqFactor=1;}
					if ((OrderPackQty!="")&&(parseFloat(OrderPackQty)!=0)){
						Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
					}else{
						Qty=parseFloat(OrderBaseQty) * parseFloat(OrderFreqFactor);
						if (Qty<1) {Qty=1}
					}	
					var ret=cspRunServerMethod(CheckBeforeUpdateMethod,OrderARCIMRowid,Qty,OrderRecDepRowid);
					var Check=mPiece(ret,"^",0);
					IPNeedBillQtyFlag=mPiece(ret,"^",1);
					if (Check=='0') {
						//根据设定的最小量来判断是否需要提示库存量
						if ((OrderAlertStockQty!="")&&(OrderAlertStockQty!=0)&&(PAAdmType=="O")){
							var StockQtyStr=cspRunServerMethod(GetStockQtyMethod,OrderRecDepRowid,OrderARCIMRowid);
							var StockQty=mPiece(StockQtyStr,"^",0);
							var PackedQty=mPiece(StockQtyStr,"^",1);
							var LogicQty=parseFloat(StockQty)-parseFloat(PackedQty);
							if (parseFloat(OrderAlertStockQty)>LogicQty){
								var RtnNoEnough=confirm(OrderName+t['Alert_QtyNoEnough']+","+t['STOCKQTY']+LogicQty);
								if(RtnNoEnough==false) return false;
								return true;	
							}
						}
						var RtnNoEnough=confirm(OrderName+t['Alert_QtyNoEnough']);
						if(RtnNoEnough==false) return false;
						return true;	
					}    
    		}		
						
			}
			var GroupStatus=DHCC_GetElementData(tGroupId+"GroupStatus");
			if((GroupStatus=="To Stop")||(GroupStatus=="Stop")||(GroupStatus=="R")){
				GroupStatus="S";
			}
			if ((VenousFillingFlag==true)&&(IncludeSolventFlag==false)&&(GroupStatus!="S")) {
				alert("第"+GroupRow+'组药品是"建立静脉通道"组,请选择[通道液]');
				return false;
			}
			
		}
	}catch(e){alert(e.message)}
	return true;
}

function isInteger(objStr){
	var reg=/^\+?[0-9]*[0-9][0-9]*$/;
	var ret=objStr.match(reg);
  if(ret==null){return false}else{return true}
}

function GetChangedMultiDate(OrderMultiDate,OldOrderMultiDate){
	var ChangedOrderMultiDate="";
	var SubOldDate=OldOrderMultiDate.split(",");
	for (var j=0;j<=SubOldDate.length-1;j++) {
	  if (OrderMultiDate.indexOf(SubOldDate[j])==-1){
	  	if (ChangedOrderMultiDate=="") {
	  		ChangedOrderMultiDate=SubOldDate[j];
	  	}else{
	  		ChangedOrderMultiDate=ChangedOrderMultiDate+","+SubOldDate[j];
	  	}
	  }
	}
	return ChangedOrderMultiDate;
}

function GetOrderDataOnAdd(SheetRowId){
  var GroupStr="";
	try{
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var GroupNo=GetGroupRow(objtbl,i);
			var grouptbl=GetCellObj('SheetGroup',GroupNo);
			var f=websys_getChildElements(grouptbl);
			for (var j=0;j<f.length;j++) {
				if (f[j].tagName=="TABLE") {
					if (f[j].id.substring(0,7)=="tGroupM"){
						var SubObjId=f[j].id.split("tGroupM");
						var GroupRow=SubObjId[1];
					}
				}
			}
			
			var OrderItemStr="";
			var tGroupId="tGroup"+GroupRow;	
			var ChangeMultiDateObj=document.getElementById(tGroupId+'ChangeMultiDate');		
			if (ChangeMultiDateObj){
				var OrderMultiDate=DHCC_GetElementData(tGroupId+"ChangeMultiDate");
				var OldOrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
				var ChangedOrderMultiDate=GetChangedMultiDate(OrderMultiDate,OldOrderMultiDate);
				var StopedOrderMultiDate=OldOrderMultiDate;
			}else{
				var OrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
				var ChangedOrderMultiDate="";
				var StopedOrderMultiDate="";
			}
			if (OrderMultiDate!=""){
				OrderMultiDate=cspRunServerMethod(ConverDateMethod,OrderMultiDate,1);
			}
			var VenousFillingFlag=DHCC_GetElementData(tGroupId+"VenousFillingFlag");
			if (VenousFillingFlag==true){VenousFillingFlag="Y"}else{VenousFillingFlag="N"}
			var GroupStatus=DHCC_GetElementData(tGroupId+"GroupStatus");
			if(GroupStatus=="To Stop"){
				GroupStatus="S";
			}
			//alert("第"+i+"组"+"			GroupRow=="+GroupRow+"			f.length=="+f.length+"			OrderMultiDate=="+OrderMultiDate);

			var GroupRemark=DHCC_GetElementData(tGroupId+"Remark");
			var itemtbl=document.getElementById(tGroupId);
			var itemrows=itemtbl.rows.length;
			//alert("itemrows=="+itemrows);
			//return "";
			var NewItemNo=0;
			for (var j=1; j<itemrows; j++){
				var GroupItemNo=j
				var Row=GetRow(tGroupId,j);
				var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
				//alert("OrderARCIMRowid="+OrderARCIMRowid+"  OrderItemRowid="+OrderItemRowid+"    SheetRowId="+SheetRowId+"    "+((OrderARCIMRowid!="")&&(((OrderItemRowid=="")&&(SheetRowId==""))||((OrderItemRowid!="")&&(SheetRowId!="")))));
				//if ((OrderARCIMRowid!="")&&(((OrderItemRowid=="")&&(SheetRowId==""))||((OrderItemRowid!="")&&(SheetRowId!="")))){
				if (OrderARCIMRowid!=""){
					var OrderName=GetColumnData(tGroupId,"OrderName",Row);
					//alert("OrderName="+OrderName+"  Row="+Row+"  j="+j)
					var OrderType=GetColumnData(tGroupId,"OrderType",Row);
			    var OrderPriorRowid=GetColumnData(tGroupId,"OrderPriorRowid",Row);
					var OrderRecDepRowid=GetColumnData(tGroupId,"OrderRecDepRowid",Row);
					var OrderFreqRowid=GetColumnData(tGroupId,"OrderFreqRowid",Row);
					var OrderDurRowid=GetColumnData(tGroupId,"OrderDurRowid",Row);
			    var OrderInstrRowid=GetColumnData(tGroupId,"OrderInstrRowid",Row);
			    var OrderDoseQty=GetColumnData(tGroupId,"OrderDoseQty",Row);	
			    var OrderDoseUOMRowid=GetColumnData(tGroupId,"OrderDoseUOMRowid",Row);
			    var OrderPackQty=GetColumnData(tGroupId,"OrderPackQty",Row);
			    var OrderPrice=GetColumnData(tGroupId,"OrderPrice",Row);
			    var OrderSeqNo=GetColumnData(tGroupId,"OrderSeqNo",Row);
			    var PHPrescType=GetColumnData(tGroupId,"OrderPHPrescType",Row);
			    var BillTypeRowid=GetColumnData(tGroupId,"OrderBillTypeRowid",Row);
			    var SheetItemRowid=GetColumnData(tGroupId,"SheetItemRowid",Row);
			    var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
			    var OrderSkinTest="";
			    var OrderARCOSRowid=GetColumnData(tGroupId,"OrderARCOSRowid",Row);
			    var OrderDrugFormRowid=GetColumnData(tGroupId,"OrderDrugFormRowid",Row);
			    var OrderStartDate="";
			    var OrderStartTime="";
			    var OrderMasterSeqNo="";
			    var MasterSeqNo="";
			    if (OrderItemRowid=="") var NewItemNo=NewItemNo+1
			    if (NewItemNo==1){
			    	var MasterSeqNo=j
			    }else {
			    	OrderMasterSeqNo=MasterSeqNo;     
			    }
			    
			    var OrderSeqNo=j;    
			    var OrderDepProcNotes=GetColumnData(tGroupId,"OrderDepProcNote",Row);
	  	    var OrderPhSpecInstr="";
	  	    var OrderCoverMainIns="";
	  	    var OrderActionRowid="";
	  	    var OrderEndDate="";
	  	    var OrderEndTime="";
	  	    if (OrderSkinTest==true){OrderSkinTest="Y"}else{OrderSkinTest="N"}
	  	    if (OrderCoverMainIns==true){OrderCoverMainIns="Y"}else{OrderCoverMainIns="N"}
					var OrderLabSpecRowid="";
					var OrderNotifyClinician="";
	  	    if (OrderNotifyClinician==true){OrderNotifyClinician="Y"}else{OrderNotifyClinician="N"}
			    var OrderPresc=GetColumnData(tGroupId,"OrderPresc",Row);
	  	    if (OrderPresc==true){OrderPresc="Y"}else{OrderPresc="N"}
	  	    var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
	  	    if(SheetItemStatus=="To Stop"){
	  	    	SheetItemStatus="S";
	  	    	var StopItemStr=OrderItemRowid+"!"+StopedOrderMultiDate;
	  	    	if (StopStr=="")  StopStr=StopItemStr;
	  	    	else  StopStr=StopStr+"^"+StopItemStr;	
	  	    }else{
	  	    	if(ChangedOrderMultiDate!=""){
	  	    		var StopItemStr=OrderItemRowid+"!"+ChangedOrderMultiDate;
	  	    		if (StopStr=="")  StopStr=StopItemStr;
	  	    		else  StopStr=StopStr+"^"+StopItemStr;
	  	    	}
	  	    }
	  	    var SolventFlag=GetColumnData(tGroupId,"SolventFlag",Row);
	  	    if (SolventFlag==true){SolventFlag="Y"}else{SolventFlag="N"}
	  	    
			    var OrderQtySum="";
			    if (OrderType=="R"){
					  var freq=GetColumnData(tGroupId,"OrderFreqFactor",Row);   
						var dur=GetColumnData(tGroupId,"OrderDurFactor",Row);
					  var Interval=GetColumnData(tGroupId,"OrderFreqInterval",Row);
						if ((Interval!="") && (Interval!=null)) {
							var convert=Number(dur)/Number(Interval)
							var fact=(Number(dur))%(Number(Interval));
							if (fact>0) {
								fact=1;
							} else {
								fact=0;
							}
							dur=Math.floor(convert)+fact;
						}	
						if (freq=="") freq=1;
					  OrderQtySum=parseFloat(OrderDoseQty)*parseFloat(dur)*parseFloat(freq);
					  OrderQtySum=OrderQtySum.toFixed(4);
					  //alert(OrderQtySum);
			    }else{
			    	OrderQtySum=OrderPackQty;
			    	OrderPackQty="";
			    }
			    //alert("OrderDoseQty="+OrderDoseQty+"         dur="+dur+"         freq="+freq+"         OrderQtySum="+OrderQtySum+"         OrderType="+OrderType);
			    if (OrderDoseQty==""){OrderDoseUOMRowid=""}
			    OrderItem=OrderARCIMRowid+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderPackQty+"^"+OrderPrice;
			    OrderItem=OrderItem+"^"+OrderRecDepRowid+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes;
			    OrderItem=OrderItem+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderInstrRowid;
			    OrderItem=OrderItem+"^"+PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+OrderSkinTest+"^"+OrderPhSpecInstr+"^"+OrderCoverMainIns;
			    OrderItem=OrderItem+"^"+OrderActionRowid+"^"+OrderARCOSRowid+"^"+OrderEndDate+"^"+OrderEndTime+"^"+OrderLabSpecRowid+"^"+OrderMultiDate;
			    OrderItem=OrderItem+"^"+OrderNotifyClinician+"^"+OrderItemRowid+"^"+SheetItemRowid+"^"+GroupNo+"||"+GroupItemNo+"^"+OrderPresc+"^"+SheetItemStatus;
			    OrderItem=OrderItem+"^"+VenousFillingFlag+"^"+SolventFlag+"^"+GroupStatus;
			    //alert("GroupNo="+GroupNo+"  Row="+Row+"  j="+j+"  SheetItemRowid="+SheetItemRowid+"  OrderItemRowid="+OrderItemRowid+"    OrderName="+OrderName+"    OrderARCIMRowid="+OrderARCIMRowid+"    OrderDoseUOMRowid="+OrderDoseUOMRowid+"***********"+OrderItem); 
			    if (OrderItemStr==""){OrderItemStr=OrderItem}else{OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem}
				}
			}
			if (OrderItemStr!=""){
				if (GroupStr==""){GroupStr=GroupRemark+String.fromCharCode(3)+OrderItemStr;}else{GroupStr=GroupStr+String.fromCharCode(4)+GroupRemark+String.fromCharCode(3)+OrderItemStr;}
			}
		}
		var SheetRemark=DHCC_GetElementData("SheetRemark");
		var SheetCycle=DHCC_GetElementData("Cycle");
		var SheetStartDate=DHCC_GetElementData("StartDate");
		var SheetEndDate=DHCC_GetElementData("EndDate");

		if (GroupStr!=""){
			GroupStr=SheetCycle+"^"+SheetStartDate+"^"+SheetEndDate+"^"+SheetRemark+String.fromCharCode(4)+GroupStr;
		}
	}catch(e){
		alert(e.message);
		GroupStr="";
	}
	return GroupStr;
}

function SaveOrderItems(OrderItemStr){
	var UserAddRowid="";
	var UserAddDepRowid="";
	var DoctorRowid="";
  UserAddRowid=session['LOGON.USERID'];
  UserAddDepRowid=session['LOGON.CTLOCID']; 
  //如果登陆人为医生?就加入医生?如果登陆人为护士?并替医生录入?还是加入医生
  //如果登陆人为护士?而且没有选择医生?就加入护士
  if (LogonDoctorType=="DOCTOR"){
  	DoctorRowid=LogonDoctorID;
  }else{
    var obj=document.getElementById('DoctorID');
  	if (obj) DoctorRowid=obj.value;
  	if (DoctorRowid=="") {DoctorRowid=LogonDoctorID;}
  }

  var SheetRowId=DHCC_GetElementData("SheetRowId");
  //alert("SheetRowId="+SheetRowId);
	var ModifyFlag=DHCC_GetElementData('ModifyFlag');
	var ChangeFlag=DHCC_GetElementData('ChangeFlag');
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	//alert("   SaveOrderItemsMethod="+SaveOrderItemsMethod+"   EpisodeID="+EpisodeID+"   OrderItemStr="+OrderItemStr+"   UserAddRowid="+UserAddRowid+"   UserAddDepRowid="+UserAddDepRowid+"   DoctorRowid="+DoctorRowid);
	if (SheetRowId==""){
		var ret=cspRunServerMethod(SaveOrderItemsMethod,EpisodeID,OrderItemStr,UserAddRowid,UserAddDepRowid,DoctorRowid)
	}else{	
			var ret=cspRunServerMethod(SaveOrderItemsMethod,SheetRowId,EpisodeID,OrderItemStr,UserAddRowid,UserAddDepRowid,DoctorRowid)
	}
	return ret;
}

function BuildClickHandler(e){
	UpdateFlag=false;
	var obj=document.getElementById('Save');
	if (obj){
		obj.onclick=SaveClickHandler;
		obj.disabled=false;
	}
	var obj=document.getElementById("Build");
	if (obj){
		obj.disabled=true;
		obj.onclick="";
	}
	if (!CheckDiagnose("R")){
  	var obj=document.getElementById("Build");
		if (obj){
			obj.disabled=false;
			obj.onclick=BuildClickHandler;
			return;
		}
  }
  
	var PrescOrderItemStr="";
	var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var GroupNo=GetGroupRow(objtbl,i);
		var grouptbl=GetCellObj('SheetGroup',GroupNo);
		var f=websys_getChildElements(grouptbl);
		for (var j=0;j<f.length;j++) {
			if (f[j].tagName=="TABLE") {
				if (f[j].id.substring(0,7)=="tGroupM"){
					var SubObjId=f[j].id.split("tGroupM");
					var GroupRow=SubObjId[1];
				}
			}
		}
		var tGroupId="tGroup"+GroupRow;
		var itemtbl=document.getElementById(tGroupId);
		var itemrows=itemtbl.rows.length;
		for (var j=1; j<itemrows; j++){
			var Row=GetRow(tGroupId,j);
		  var OrderPresc=GetColumnData(tGroupId,"OrderPresc",Row);
		  var OrderName=GetColumnData(tGroupId,"OrderName",Row);
		 	var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",Row);
		  var OrderPresced=GetColumnData(tGroupId,"OrderPresced",Row);
		  var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
		  
		  if ((OrderPresc)&&(OrderPresced==0)&&(SheetItemStatus!="S")&&(SheetItemStatus!="R")){
		  	var OrderName=GetColumnData(tGroupId,"OrderName",Row);
			  var OrderARCIMRowid=GetColumnData(tGroupId,"OrderARCIMRowid",Row);
			  var OrderItemRowId=GetColumnData(tGroupId,"OrderItemRowid",Row);
			  var OrderPackQty=GetColumnData(tGroupId,"OrderPackQty",Row);
			  var OrderRecDepRowid=GetColumnData(tGroupId,"OrderRecDepRowid",Row);	
			  var BillTypeRowid=GetColumnData(tGroupId,"OrderBillTypeRowid",Row);
			  
			  var OrderBaseQty=GetColumnData(tGroupId,"OrderBaseQty",Row);
			  var OrderFreqFactor=GetColumnData(tGroupId,"OrderFreqFactor",Row);
			  var OrderConFac=GetColumnData(tGroupId,"OrderConFac",Row);
			  var OrderAlertStockQty=GetColumnData(tGroupId,"OrderAlertStockQty",Row);
			   
			  var Qty=1;
				if (OrderBaseQty=="") {OrderBaseQty=1;}
				if (OrderFreqFactor==""){OrderFreqFactor=1;}
				if ((OrderPackQty!="")&&(parseFloat(OrderPackQty)!=0)){
					Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
				}else{
					Qty=parseFloat(OrderBaseQty) * parseFloat(OrderFreqFactor);
					if (Qty<1) {Qty=1}
				}
				var ret=cspRunServerMethod(CheckBeforeUpdateMethod,OrderARCIMRowid,Qty,OrderRecDepRowid);
						var Check=mPiece(ret,"^",0);
						IPNeedBillQtyFlag=mPiece(ret,"^",1);
						if (Check=='0') {
							//根据设定的最小量来判断是否需要提示库存量
							if ((OrderAlertStockQty!="")&&(OrderAlertStockQty!=0)&&(PAAdmType=="O")){
								var StockQtyStr=cspRunServerMethod(GetStockQtyMethod,OrderRecDepRowid,OrderARCIMRowid);
								var StockQty=mPiece(StockQtyStr,"^",0);
								var PackedQty=mPiece(StockQtyStr,"^",1);
								var LogicQty=parseFloat(StockQty)-parseFloat(PackedQty);
								if (parseFloat(OrderAlertStockQty)>LogicQty){
									alert(OrderName+t['QTY_NOTENOUGH']+","+t['STOCKQTY']+LogicQty);
									var obj=document.getElementById("Build");
									if (obj){
										obj.disabled=false;
										obj.onclick=BuildClickHandler;
										return;
									}
								}
							}
							alert(OrderName+t['QTY_NOTENOUGH']);
							var obj=document.getElementById("Build");
							if (obj){
								obj.disabled=false;
								obj.onclick=BuildClickHandler;
								return;
							}
						}
			  
				if (BillTypeRowid==""){
					alert(OrderName+t['NO_BillType']);
					FocusRowIndex=i;
					SetFocusColumn(tGroupId,"OrderBillType",Row);
					var obj=document.getElementById("Build");
					if (obj){
						obj.disabled=false;
						obj.onclick=BuildClickHandler;
						return;
					}
				}
				if (PrescOrderItemStr=="") {
		  		PrescOrderItemStr=OrderItemRowId;
		  	}else{
		  		PrescOrderItemStr=PrescOrderItemStr+"^"+OrderItemRowId;
		  	}
		  }				
		}
	}
	SaveClickHandler();	//   点"生成处方",自动保存化疗单;因为生成处方前,需要先保存费别等信息
	var SheetRowId=DHCC_GetElementData("SheetRowId");
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	//alert("SheetRowId="+SheetRowId+"   PrescOrderItemStr="+PrescOrderItemStr+"   EpisodeID="+EpisodeID);
	//return;
  if ((SheetRowId!="")&&(PrescOrderItemStr!="")){
		var ret=cspRunServerMethod(PrescMethod,SheetRowId,EpisodeID,PrescOrderItemStr);
		if (ret==0){
			window.location.href="dhcadmsheet.edit.csp?SheetRowId="+SheetRowId+"&EpisodeID="+EpisodeID+"&SheetEpisodeID="+SheetEpisodeID+"&mradm="+mradm;	
			return;
		}else(
			alert("Prescript Error")
		)
	}
}

function PinNumberValid(ObjName){
	var obj=document.getElementById(ObjName);
	var PinNumberobj=document.getElementById("PinNumber");
	if (PinNumberobj){
		var PinNumber=PinNumberobj.value;
		if (PinNumber==""){
			alert(t['Input_PinNumber']);
			obj.disabled=false;
			websys_setfocus('PinNumber');
			return -1
		}else{
				var ret=cspRunServerMethod(PinNumberMethod,session['LOGON.USERID'],PinNumber)
				if (ret=="-4"){
					alert(t['Wrong_PinNumber']);
					obj.disabled=false;
					websys_setfocus('PinNumber');
					return -4
				}
		}
	}
	return 0;
}

function SaveClickHandler(){
	UpdateFlag=false;
	var obj=document.getElementById("Save");
	if (obj){
		obj.disabled=true;
		obj.onclick="";
	}
	var ret=CheckBeforeUpdate();
	if (ret==false) {
		obj.disabled=false;
		obj.onclick=SaveClickHandler;
		return false;
	}
	var PinNumberValidFlag=0
	var Sourceobj=websys_getSrcElement(e);
	if (Sourceobj.id=="Save")PinNumberValidFlag=PinNumberValid("Save")
	if (PinNumberValidFlag!=0) {
		obj.onclick=SaveClickHandler;	
		return websys_cancel();
	}
			
	var SheetRowId=DHCC_GetElementData("SheetRowId");
	var OrderItemStr=GetOrderDataOnAdd(SheetRowId);
	//alert("OrderItemStr=   "+OrderItemStr);
	if (OrderItemStr=="") {
		obj.onclick=SaveClickHandler;
		obj.disabled=false;
		return false;
	}	
	
	var SheetRowId=DHCC_GetElementData("SheetRowId");
	var ModifyFlag=DHCC_GetElementData('ModifyFlag');
	var UpdateFlag=0
	if (SheetRowId=="") {
		var SheetRowId=SaveOrderItems(OrderItemStr);
	}else{
		var UpdateFlag=SaveOrderItems(OrderItemStr);	
	}
	if (SheetRowId=="-100") {
		alert(t['Fail_SaveOrder']);
		obj.disabled=false;
		obj.click=SaveClickHandler;
		return websys_cancel();
	}
	if (UpdateFlag!=0)  {
		alert("FailToUpdate!");	
	}
	
	DHCC_SetElementData("SheetRowId",SheetRowId);
	var mradm=document.getElementById("mradm").value;
	UpdateFlag=true;
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	TransMessageToInterface(EpisodeID,StopStr,"Stop");
	window.location.href="dhcadmsheet.edit.csp?SheetRowId="+SheetRowId+"&EpisodeID="+EpisodeID+"&mradm="+mradm; 
	return true;
}

function BtnPrintPreHandler()
{
	var SheetRowId=DHCC_GetElementData('SheetRowId');
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	if (SheetRowId==""){
		return;
	} 
	var PapmiOPNo,Medcare,Pname,Ctloc,Printtime="";
	var Periods=document.getElementById("Cycle").value;
	//第      周期    **** 年  ** 月  ** 日 至    ****  年 ** 月 ** 日
	var StartDateValue=document.getElementById("StartDate").value;
	var EndDateValue=document.getElementById("EndDate").value;
	var ChemotherapyTitle="(第 "+Periods+" 周期"+"    "+StartDateValue.split("/")[2]+" 年 "+StartDateValue.split("/")[1]+" 月 "+StartDateValue.split("/")[0]+" 日  至  "+ EndDateValue.split("/")[2]+" 年 "+EndDateValue.split("/")[1]+" 月 "+EndDateValue.split("/")[0]+" 日)";
	
	//就诊卡号??        病历号??          姓名??           就诊科室??     打印时间??   医生 ******
	var GetPatientInfo=document.getElementById('GetPatientInfo');
		if (GetPatientInfo) {var encmeth=GetPatientInfo.value;} else {var encmeth=''};
  	if (encmeth!="") {
  			var SheetRowId=DHCC_GetElementData('SheetRowId');
		    GetPatientInfoValue=cspRunServerMethod(encmeth,SheetRowId); 
		    if (GetPatientInfoValue!=""){
		    	  var PapmiOPNo=GetPatientInfoValue.split("^")[1];
		    	  var insuranceType=GetPatientInfoValue.split("^")[6];
			      var Medcare=GetPatientInfoValue.split("^")[18];
			      var Pname=GetPatientInfoValue.split("^")[2];
			      var Ctloc=GetPatientInfoValue.split("^")[27];
			      var Printtime=GetPatientInfoValue.split("^")[24];
			      var Doctor=GetPatientInfoValue.split("^")[28];
			 }
		}
	var MyPara="";
	    MyPara="Title"+String.fromCharCode(2)+ChemotherapyTitle;
	    MyPara=MyPara+"^PapmiOPNo"+String.fromCharCode(2)+PapmiOPNo;
	    MyPara=MyPara+"^Medcare"+String.fromCharCode(2)+Medcare;
	    MyPara=MyPara+"^insuranceType"+String.fromCharCode(2)+insuranceType;
	    MyPara=MyPara+"^PName"+String.fromCharCode(2)+Pname;
	    MyPara=MyPara+"^Ctloc"+String.fromCharCode(2)+Ctloc;
	    MyPara=MyPara+"^Printtime"+String.fromCharCode(2)+Printtime;
	    MyPara=MyPara+"^Doctor"+String.fromCharCode(2)+Doctor;
	    MyPara=MyPara+"^EpisodeIDBar"+String.fromCharCode(2)+"*"+EpisodeID+"B*";
	    MyPara=MyPara+"^AddDateTime"+String.fromCharCode(2)+SheetAddDate+"  "+SheetAddTime;
	     
	var MyList,OrderName,spec,No,note,GroupNumber,Instruction,remark="";
	try{	
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		MyList=String.fromCharCode(2)+"";
		for (var i=1; i<rows; i++){
			var GroupNo=GetGroupRow(objtbl,i);
			var grouptbl=GetCellObj('SheetGroup',GroupNo);
			var f=websys_getChildElements(grouptbl);
			for (var j=0;j<f.length;j++) {
				if (f[j].tagName=="TABLE") {
					if (f[j].id.substring(0,7)=="tGroupM"){
						var SubObjId=f[j].id.split("tGroupM");
						var GroupRow=SubObjId[1];
					}
				}
			}
			var tGroupId="tGroup"+GroupRow;
			var itemtbl=document.getElementById(tGroupId);
			var itemrows=itemtbl.rows.length;
			
			var GroupNumber="第"+GroupRow+"组 ------------------------";
			MyList = MyList + String.fromCharCode(2)+" "+"^"+"------------------------ "+GroupNumber+"^"+" "+"^"+" "+"^"+" ";
			for (var j=1; j<itemrows; j++){
				var Row=GetRow(tGroupId,j);
				var OrderSeqNo=GetColumnData(tGroupId,"OrderSeqNo",Row);
				var FullOrderName=GetColumnData(tGroupId,"OrderName",Row);
				var OrderName=GetCommodityName(FullOrderName);
				
				var OrderStatus=""
				var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
				var OrderItemStopDate=GetColumnData(tGroupId,"OrderItemStopDate",Row);
				var TempDateSub=OrderItemStopDate.split("/");
				OrderItemStopDate=TempDateSub[1]+"."+TempDateSub[0];
				OrderStopStatus="<"+OrderItemStopDate+"停>";
				var OrderItemAddDate=GetColumnData(tGroupId,"OrderItemAddDate",Row);
				var TempDateSub=OrderItemAddDate.split("/");
				OrderItemAddDate=TempDateSub[1]+"."+TempDateSub[0];
				OrderAddStatus="<"+OrderItemAddDate+"增>";
				//if (OrderItemStopDate!="") OrderItemStopDate=TransformDate(OrderItemStopDate);
				if (SheetItemStatus=="S") {
					OrderStatus=OrderStopStatus;
				}else {
					if (SheetItemStatus=="A"){
						OrderStatus=OrderAddStatus;
					}else if (SheetItemStatus=="R"){
						OrderStatus=OrderStopStatus+""+OrderAddStatus;
					}
				}
				if (OrderStatus!="") {
					MyList = MyList + String.fromCharCode(2)+"^"+OrderStatus+"  "+OrderName+"^ ^ ^ ^"+"";
					OrderName=""
				}
				var DoseQty=GetColumnData(tGroupId,"OrderDoseQty",Row);
			  var DoseUOM=GetColumnData(tGroupId,"OrderDoseUOM",Row);
				var Frequence=GetColumnData(tGroupId,"OrderFreq",Row);
				var Instruction=GetColumnData(tGroupId,"OrderInstr",Row);
				var OrderDepProcNote=GetColumnData(tGroupId,"OrderDepProcNote",Row);
				var Instruction=Instruction+" "+OrderDepProcNote;
				if (Instruction.length>8){
	    		  MyList = MyList + String.fromCharCode(2)+""+"^"+OrderName+"^"+""+"^"+DoseQty+DoseUOM+"^"+Frequence+" "+Instruction.substring(0,8)+"^"+"";
	    		  for (var q=0;q<=((Instruction.length-8)/28);q++) {
	    		  	MyList = MyList + String.fromCharCode(2)+""+"^  "+Instruction.substring(8+28*q,36+28*q)+"^"+""+"^"+""+""+"^"+""+" "+""+"^"+"";				
						}
			  	  
			  }else{
			  		MyList = MyList + String.fromCharCode(2)+""+"^"+OrderName+"^"+""+"^"+DoseQty+DoseUOM+"^"+Frequence+" "+Instruction+"^"+"";
			  }
		 	} 	
			var OrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
			var GroupRemark=DHCC_GetElementData(tGroupId+"Remark");
			
			//MyList = MyList + String.fromCharCode(2)+""+"^"+OrderMultiDate+"^"+""+"^"+""+""+"^"+"";
			OrderMultiDate = OrderMultiDate
			MyList = MyList + StringSplit(OrderMultiDate);

			
			//MyList = MyList + String.fromCharCode(2)+""+"^"+GroupRemark+"^"+""+"^"+""+""+"^"+"";	
			if(GroupRemark!=""){
			  GroupRemark = "组备注: " + GroupRemark
        MyList = MyList+StringSplit(GroupRemark);
			}
			
		}		
	}
	catch(e){
		alert(e.message);
	}
		MyList = MyList + String.fromCharCode(2)+" "+"^"+"------------------------------------------------------- "+"^"+" "+"^"+" "+"^"+" "+"^"+" ";
		
		var SheetRemark = DHCC_GetElementData("SheetRemark");
		//MyList = MyList + String.fromCharCode(2)+""+"^"+SheetRemark+"^"+""+"^"+""+""+"^"+"";	
		if(SheetRemark!=""){
				SheetRemark=CancelSplitCode(SheetRemark,String.fromCharCode(13,10));
			  SheetRemark ="化疗单备注:  " + SheetRemark
		    MyList = MyList+StringSplit(SheetRemark);
		}
		var SheetLog = DHCC_GetElementData("SheetLog");
		if (SheetLog!=""){
			MyList = MyList + String.fromCharCode(2)+" "+"^"+"------------------------------------------------------- "+"^"+" "+"^"+" "+"^"+" "+"^"+" ";
			SheetLog=FormatString(SheetLog,String.fromCharCode(13,10));
			SheetLog ="日志:  " + SheetLog
			MyList = MyList+StringSplit(SheetLog);
		}
		//return;
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,MyList);
}

function CancelSplitCode(CrudeStr,SplitCode){
	//去掉字符串中的特殊符号
	var SubCrudeStr=CrudeStr.split(SplitCode);
	var FormatStr="";
	for (var k=0;k<=SubCrudeStr.length-1;k++) {
		if (FormatStr==""){
			FormatStr=SubCrudeStr[k];
		}else{
			FormatStr=FormatStr+""+SubCrudeStr[k];
		}						
	}
	return FormatStr;
}

function FormatString(CrudeStr,SplitCode){
	//格式化字符串
	var FormatStr="";
	var SubCrudeStr=CrudeStr.split("<");
	for (var i=1;i<SubCrudeStr.length;i++){
		var SubFormatStr=""
		var ItemCrudeStr=SubCrudeStr[i].split(SplitCode);
		for (var k=0;k<=ItemCrudeStr.length-2;k++) {
			if (SubFormatStr==""){
				SubFormatStr=ItemCrudeStr[k]+" ";
			}else{
				SubFormatStr=SubFormatStr+ItemCrudeStr[k]+"; ";
			}			
		}	
		SubFormatStr=SubFormatStr.substring(0,SubFormatStr.length-2);
		SubFormatStr="<"+SubFormatStr+".   "
		if (FormatStr==""){
			FormatStr=SubFormatStr;
		}else{
			FormatStr=FormatStr+" "+SubFormatStr;
		}			
		
	}
	return FormatStr;
}

function StringSplit(String1){
      var len=String1.length;
		  var len1=0;
  		var startpos=0;
  		var endpos=0;
  		var Mylist1=String.fromCharCode(2)+"";
  		for (var j=0;j<len;j++) {
  			var char1=String1.substring(j,j+1);
  			endpos=j+1;
  			if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
  			if (len1>54) {
  				      var MyList1 = MyList1 + String.fromCharCode(2)+""+"^"+String1.substring(startpos,endpos)+"^"+""+"^"+""+""+"^"+""+"^"+"";
  				      startpos=endpos;
  				      len1=0;
  			}
  		}
  		if (len1!=0) {   var MyList1 = MyList1 + String.fromCharCode(2)+""+"^"+String1.substring(startpos,endpos)+"^"+""+"^"+""+""+"^"+""+"^"+"";}
      return MyList1;
}

function CheckChinese(char1){
	if(escape(char1).indexOf("%u")!=-1) return true;
	return false;
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function GetCommodityName(FullOrderName){
	var Flag=FullOrderName.split("(").length
	if (Flag>1){
		var OrderNameTail=""
		var FullOrderNameItem=FullOrderName.split("(")
		var OrderNameHead=FullOrderNameItem[0]
		var FullOrderNameItem=FullOrderName.split(")")
		var OrderNameTail=FullOrderNameItem[1]
		var CommodityName=OrderNameHead+OrderNameTail
		return CommodityName;	 
	}else{ 
		return FullOrderName;
	}
}

function CancelClickHandler(){
		PinNumberValidFlag=PinNumberValid("CancelSheet")
		if (PinNumberValidFlag!=0) return websys_cancel();
		var SheetRowId=DHCC_GetElementData('SheetRowId');
		if (SheetRowId=="") return;
		var mradm=document.getElementById("mradm").value;
		var returnReg=confirm(t['Cancel_confirm']);
		if(returnReg==false) return;
		UserRowId=session['LOGON.USERID'];
		StopTransfusion();
		//return;
		var RtnValue=cspRunServerMethod(CancelSheetMethod,SheetRowId,UserRowId)
		if (RtnValue==0){
			alert(t['Cancel_successful']);
		} else{
			alert("化疗单停止失败,请联系信息中心");
			return;
		} 
		var CopyAndCreat=confirm(t['CreatNew_confirm']);
		if(CopyAndCreat==true){
			window.location.href="dhcadmsheet.edit.csp?CopySheetRowId="+SheetRowId+"&SheetRowId="+""+"&EpisodeID="+EpisodeID+"&mradm="+mradm;	
		}else{
			window.location.href="dhcadmsheet.edit.csp?SheetRowId="+""+"&EpisodeID="+EpisodeID+"&mradm="+mradm; 
		}
}	

function ModifyClickHandler(){
	//PinNumberValidFlag=PinNumberValid("Save")
	//if (PinNumberValidFlag!=0) return websys_cancel();
	var SheetRowId=DHCC_GetElementData('SheetRowId');
	if (SheetRowId=="") return;
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	var mradm=document.getElementById("mradm").value;
	var returnReg=confirm(t['Modify_confirm']);
	if(returnReg==false) return;
	window.location.href="dhcadmsheet.edit.csp?SheetRowId="+SheetRowId+"&EpisodeID="+EpisodeID+"&SheetEpisodeID="+SheetEpisodeID+"&mradm="+mradm+"&ModifyFlag="+1;	  
}	

function ChangeClickHandler(){
	//PinNumberValidFlag=PinNumberValid("Save")
	//if (PinNumberValidFlag!=0) return websys_cancel();
	var SheetRowId=DHCC_GetElementData('SheetRowId');
	if (SheetRowId=="") return;
	var EpisodeID=DHCC_GetElementData('EpisodeID');
	var mradm=document.getElementById("mradm").value;
	var returnReg=confirm(t['Change_confirm']);
	if(returnReg==false) return;
	window.location.href="dhcadmsheet.edit.csp?SheetRowId="+SheetRowId+"&EpisodeID="+EpisodeID+"&SheetEpisodeID="+SheetEpisodeID+"&mradm="+mradm+"&ChangeFlag="+1;	  
}	

function StopTransfusion(){
	EpisodeID=document.getElementById('EpisodeID').value;
	try{
		var objtbl=document.getElementById('tDHCPAAdmSheet_Edit');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var GroupNo=GetGroupRow(objtbl,i);
			var grouptbl=GetCellObj('SheetGroup',GroupNo);
			var f=websys_getChildElements(grouptbl);
			for (var j=0;j<f.length;j++) {
				if (f[j].tagName=="TABLE") {
					if (f[j].id.substring(0,7)=="tGroupM"){
						var SubObjId=f[j].id.split("tGroupM");
						var GroupRow=SubObjId[1];
					}
				}
			}
			
			var tGroupId="tGroup"+GroupRow;	
			var itemtbl=document.getElementById(tGroupId);
			var itemrows=itemtbl.rows.length;
			
			for (var j=1; j<itemrows; j++){
				var Row=GetRow(tGroupId,j);
				var OrderItemRowid=GetColumnData(tGroupId,"OrderItemRowid",Row);
				var SheetItemStatus=GetColumnData(tGroupId,"SheetItemStatus",Row);
				var OrderMultiDate=DHCC_GetElementData(tGroupId+"MultiDate");
	  	  if(SheetItemStatus!="S"){
	  	  	TransItemMessage(EpisodeID,OrderItemRowid,"Stop",OrderMultiDate);
	  	  }
			}
		}
	}catch(e){};
}

function TransItemMessage(EpisodeID,OEORDRowid,ActiveType,ExecDateStr){
	//有停止或新增的医嘱,向输液接口发送消息;
	//alert("EpisodeID=="+EpisodeID+"	OEORDRowid=="+OEORDRowid+"   ActiveType=="+ActiveType);
	//return;
	var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
  var soap = "<?xml   version=\"1.0\"   encoding=\"utf-8\"?>"
  soap = soap + "<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"   xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"   xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
  soap = soap + "<soap:Body>"
  soap = soap + '<RemoveAdmSheets   xmlns="http://tempuri.org/">'
  soap = soap + '<EpisodeID>'+EpisodeID+'</EpisodeID>'
  soap = soap + '<OrderItemRowId>'+OEORDRowid+'</OrderItemRowId>'
  soap = soap + '<ActiveType>'+ActiveType+'</ActiveType>'
  soap = soap + '<ExecDateStr>'+ExecDateStr+'</ExecDateStr>'
  soap = soap + "</" + 'RemoveAdmSheets' + ">"
  soap = soap + "</soap:Body>"
  soap = soap + "</soap:Envelope>"
  //alert(soap)
  var url = "http://16.22.25.246:8081/EOIISService/EOIISService.asmx";
  //var url = "http://173.116.11.199:8081/EOIISService_bjzl/EOIISService.asmx";
  xmlHttp.open("POST", url, false);
  xmlHttp.setRequestHeader("Content-Type", "text/xml;charset=utf-8");
  xmlHttp.setRequestHeader("Content-Length", soap.length);
  xmlHttp.setRequestHeader("HOST", "16.22.25.246")
  xmlHttp.setRequestHeader("SOAPAction", "http://tempuri.org/RemoveAdmSheets")
  xmlHttp.send(soap);
  //alert(soap)
  //alert("xmlHttp.status=="+xmlHttp.status);
  //如果有错误的话   返回用户填写的信息   
  if (xmlHttp.status == 200) {
      DHCCXML=xmlHttp.responseXML;
      DHCCXML=xmlHttp.responseText;
      //alert("xmlHttp.responseText==   "+xmlHttp.responseText);       
      try{
        var info = DHCCXML.getElementsByTagName('RemoveAdmSheetsResult');
        //alert(info.length)
        ResultCode=info[0].getElementsByTagName("ResultCode")[0].firstChild.data;
        ErrorMsg=info[0].getElementsByTagName("ErrorMsg")[0].firstChild.data;
        if(ActiveType=="Stop") {
	        if (ResultCode==1){
	        	alert("输液系统数据更新错误,护士未接收到停止医嘱通知,请跟信息中心联系!");
	    	 	}else if (ResultCode==2){
	    			alert(ErrorMsg);
	    		}	
        }else{
        	if (ResultCode==1){
	        	alert("输液系统数据更新错误,护士未接收到新增医嘱通知,请跟信息中心联系!");
        	}
        	
        }
      }catch(exception){    }
    } else {
    return xmlHttp.responseXML.text;
  }
}

function TransMessageToInterface(EpisodeID,MessageStr,ActiveType){
	// 保存化疗单,停止或新增医嘱需要向到银江系统发消息
	//alert("MessageStr=="+MessageStr);
	if (MessageStr=="") return;
	var SubMessageStr=MessageStr.split("^"); 
	for (var j=0;j<SubMessageStr.length;j++) { 
		var OrderItemStr=SubMessageStr[j];
		var SubOrderItemStr=OrderItemStr.split("!"); 
		var OrderItemRowid=SubOrderItemStr[0];
		var OrderItemMultiDate=SubOrderItemStr[1];
		TransItemMessage(EpisodeID,OrderItemRowid,ActiveType,OrderItemMultiDate);
	}
	return;
}