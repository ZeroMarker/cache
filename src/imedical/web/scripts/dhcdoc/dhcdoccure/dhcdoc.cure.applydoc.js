var cureApplyDataGrid;
var cureAdmDataGrid;
var SelectApplyData="-1"

$(function(){
	//初始化查询Datagride
	try{
		IntDataGride()
	}catch(e){}
	
})

function IntLod()
{
	loadAdmDataGrid() //加载就诊信息查询 
	loadApplyDataDataGrid() //加载预约单信息
	IntPatMesage() //加载患者基本信息
	IntPAADMMesage() //加载界面就诊信息
	IntDCAMesage() //加载对应申请单信息
	$("#ApplyUser").prop("innerText",session['LOGON.USERNAME']); //申请医生
	$('#ApplyDate').datebox('setValue',NowDate)
	$('#OrderArcim').keydown(lookupArcim)
	$('#OrderArcim').keyup(keyupArcim)
	$('#ImgOrderArcim').click(lookArcim)
	$('#btnSave').click(btnSave)
	IntCardType() //初始化卡类型
	$('#btnReadCard').click(ReadCard)
	$('#patNoIn').keydown(patNoInKeyDown)
	$('#patNoIn').keyup(patNoInkeyup)
	$('#cardNo').keydown(cardNoKeyDown)
	$('#btnCancel').click(btnCancelClick)
	$('#btnPrint').click(btnPrint)		
	
	
}
function btnPrint()
{
	
		var DCARowId=$('#DCARowId').val()
		if (DCARowId==""){
			$.messager.alert("提示","请选择需要打印的申请单据")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
	
		var Template=getpath+"DHCDocCurApplay.xls";
		var xlApp,xlsheet,xlBook
	 
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //用来指定模板的开始行数位置
		var xlsCurcol=1;  //用来指定开始的列数位置
		
		
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
		
		
		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var AdmID=CureApplyArr[15]
		var AppLoc=CureApplyArr[16]
		var AppInsertDate=CureApplyArr[17]
		var AppInsertTime=CureApplyArr[18]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		
		
		xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
		xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
		xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
		xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppLoc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ArcimDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyDate
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+6)=AppInsertDate+" "+AppInsertTime
	
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    xlBook.printout()
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	
}
//在excel表格中画线的方法。
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

//撤销申请单
function btnCancelClick()
{
	
	var DCARowId=$('#DCARowId').val()
	if (DCARowId==""){
		$.messager.alert("提示","请选择需要撤销的申请单记录");
		return false
	}
	var Ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CancelCureApply",DCARowId,session['LOGON.USERID'])
	if (Ret!=0){
		$.messager.alert("提示","申请单记录撤销失败"+Ret);
	}else{
		$.messager.alert("提示","撤销成功");
		loadApplyDataDataGrid();	
	}
	
	
}
//加载患者申请单列表
function loadApplyDataDataGrid()
{
	try{
	var PatientID=$('#PatientID').val()
	if (PatientID=="") return
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindCureApplyList';
	queryParams.Arg1 ="";
	queryParams.Arg2 =PatientID;
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.ArgCnt =4;
	var opts = cureApplyDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyDataGrid.datagrid('load', queryParams);
	cureApplyDataGrid.datagrid('unselectAll');
	}catch(e){}

	
}
//手工输入卡号查询
function cardNoKeyDown(e)
{
	 if(e.keyCode==13)
	 {  
		      $("#patNo").val("");
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType=="") return;
		      var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			  if (cardTypeInfo=="") return;
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return;
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			 $("#cardNo").val(cardNo);
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			 if(PatientID=="")
			 {
				 alert("卡无效");
				 $("#cardNo").val('');
				 return;
			 }
			 ChangePerson(PatientID)
			 
	}	
}

///
function patNoInkeyup()
{
	IntPAADMMesage()
}

///登记号查询患者信息
function patNoInKeyDown(e)
{

	if(e.keyCode==13)
	{
		 $("#cardNo").val("");
		  var patNo=$("#patNoIn").val();
		  if(patNo=="") return;
		  for (var i=(10-patNo.length-1); i>=0; i--) {
			patNo="0"+patNo;
		}
		$("#patNoIn").val(patNo);
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		ChangePerson(PatientID)
	}
	
	
}
//读卡
function ReadCard()
{
	$("#cardType").combobox('setValue',2)
	var cardType=$("#cardType").combobox('getValue');
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			$('#cardNo').val('')
			break;
		default:
			$('#cardNo').val(myary[1])
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			 if(PatientID=="")
			 {
				 alert("卡未查询到有效的患者信息");
				 $("#cardNo").val('');
				 return;
			 }
			 ChangePerson(PatientID)
			 break;
	}
}

//切换患者信息
function ChangePerson(PatientID)
{
	$("#PatientID").val(PatientID);
	$("#EpisodeID").val('');
	IntPatMesage()
	loadAdmDataGrid();
	loadApplyDataDataGrid()
	
}

//卡类型初始化
function IntCardType()
{
	
		//卡类型列表
    $('#cardType').combobox({      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'FindCardType'
						param.ArgCnt =0;
		}  
	});	
	

     $('#cardNo').bind('keydown', function(event){
		  
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()==""){$("#PatientID").val("");}
    });
	
	
	
}
//保存申请单
function btnSave()
{
	var AdmDr=$("#EpisodeID").val();
	if (AdmDr==""){$.messager.alert("提示","请选择患者对应就诊记录");return false}
	var AppUserID=session['LOGON.USERID'];
	var AppLocDR=session['LOGON.CTLOCID'];
	var DCAAppDate= $("#ApplyDate").datebox("getValue") 
	if (DCAAppDate==""){$.messager.alert("提示","患者对应的预约单开始日期不能为空");return false}
	var Remark=$("#ApplyRemark").val()
	var ApplyPlan=$("#ApplyPlan").val()
	var OrderArcimID=$("#OrderArcimID").val()
	if (OrderArcimID==""){$.messager.alert("提示","请选择对应的预约项目");return false}
	var ArcimReloc=$("#OrderReloc").combobox('getValue')
	if (ArcimReloc==""){$.messager.alert("提示","请选择预约项目对应的接收科室");return false}
	var DCANum=""
	
	
	var DCARowId=$('#DCARowId').val()
	if (DCARowId==""){
			var Insr=AdmDr+"^"+AppUserID+"^"+AppLocDR+"^"+DCAAppDate+"^"+Remark+"^"+ApplyPlan+"^"+OrderArcimID+"^"+ArcimReloc+"^"+DCANum;
			var OtherDesc=""
			var retNum=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CheckData","","A",Insr);
			if (retNum=="Y"){
				OtherDesc="患者已经存在相同接收科室的有效预约单,"
			}	
		
		  //申请单为空-进行新建操作
		  $.messager.confirm("提示",OtherDesc+"您将要进行新增操作是否继续?",function(r){
			if (r){
				var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CreateCureApplyNew",Insr);
				var RtnArry=ret.split("^")
				if (RtnArry[0]!=0){$.messager.alert("提示","申请单申请失败"+ret);return false}
				else {
					$('#DCARowId').val(RtnArry[1]);
					loadApplyDataDataGrid()
					IntDCAMesage()
					$.messager.alert("提示","新增成功");
					return true
			   }		
			}
			
		})
	}else{
		//申请单选中之后进行的是更新的操作
		$.messager.confirm("提示","将要更新,是否继续?",function(r){
				var UpStr=Remark+"^"+ApplyPlan+"^"+DCAAppDate+"^"+OrderArcimID+"^"+ArcimReloc
				var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","UpdateCureApply",DCARowId,AppUserID,UpStr);
				if (ret==0){
					$.messager.alert("提示","修改成功");
					loadApplyDataDataGrid()
					return true
				}else{
					$.messager.alert("提示","修改失败"+ret);
					return false
			
				}
		})
		
    }
	
}
///初始化一个申请单的信息到界面上
function IntDCAMesage()
{
	$("#ApplyStatus").prop("innerText","  ");
	var DCARowId=$('#DCARowId').val()
	if (DCARowId!=""){
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
		
		var PatID=PatientArr[0]
		var AdmID=CureApplyArr[15]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		
		$("#PatientID").val(PatID)
		$("#EpisodeID").val(AdmID);
		$("#ApplyDate").datebox("setValue",ApplyDate)
		$("#ApplyUser").prop("innerText",ApplyUser);
		$("#ApplyStatus").prop("innerText",ApplyStatus); 
		$("#ApplyRemark").prop("innerText",ApplyRemarks); 
		$("#ApplyPlan").prop("innerText",ApplyPlan); 
		$("#InsertDate").prop("innerText",InsertDate+" 	"+InsertTime+"	 申请单编号:"+DocCurNO); 
		$("#OrderArcim").val(ArcimDesc)
		$("#OrderArcimID").val(ArcimID)
		IntCombReloc(AppLocDr)
		$('#OrderReloc').combobox('setValue',RelocID)
		IntPatMesage()
		IntPAADMMesage()
		loadAdmDataGrid();
		
	}
	
}
//对应的就诊信息 界面的就诊号初始化
function IntPAADMMesage()
{
	var EpisodeID=$("#EpisodeID").val()
	$("#PAADMNO").prop("innerText",EpisodeID);
	
}

function keyupArcim()
{
	var ArcimDesc=$('#OrderArcim').val().replace(/(^\s*)|(\s*$)/g,'')
	if (ArcimDesc==""){
		$('#OrderArcimID').val('')
	}
}

//处理预约项目回车选择预约项目
function lookupArcim(e)
{
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		if ((type=='click')||((type=='keydown')&&(key==117))||(type=='keydown')&&(key==13)){
			lookArcim()	
		}
	}
	catch(e){
			
		
	}
	
}

function lookArcim()
{

	var ArcimDesc=$('#OrderArcim').val().replace(/(^\s*)|(\s*$)/g,'')
	var url='websys.lookup.csp';
	url += "?ID=20170511OrderArcim";
	url += "&CONTEXT=KDHCDoc.DHCDocCure.Apply:FindArcim";
	url += "&TLUJSF=ArcimLookUpSelect";
	url += "&P1=" + ArcimDesc;
	websys_lu(url,1,'');
	return websys_cancel();
}

///项目放大镜
function ArcimLookUpSelect(Intext)
{

	if (Intext!=""){
		var IntextArry=	Intext.split("^")
		$('#OrderArcim').val(IntextArry[0])
		$('#OrderArcimID').val(IntextArry[1])
		IntCombReloc(session['LOGON.CTLOCID'])
		
	}

}
///项目对应的接收科室
function IntCombReloc(LocID)
{
		$('#OrderReloc').combobox('loadData',{})
		$('#OrderReloc').combobox('setValue','')
		var OrderArcimID=$('#OrderArcimID').val()
		$('#OrderReloc').combobox({
			
		valueField:'Reloc',
		textField:'RelocDesc',
		url:"./dhcdoc.cure.query.combo.easyui.csp",
		onBeforeLoad:function(param){
			param.ClassName="DHCDoc.DHCDocCure.Apply";
			param.QueryName="FindArcimReloc"
			param.Arg1=OrderArcimID;
			param.Arg2="";
			param.Arg3="";
			param.Arg4=LocID;
			param.ArgCnt=4;
			
			}
		})
		
	
}
//选择申请单开始日期
function DateChange(date)
{
	
	var y=date.getFullYear();
	var m=date.getMonth()+1;
	var d=date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	return y+'-'+m+'-'+d;
}

//初始化患者基本信息
function IntPatMesage()
{
	var PatientID=$('#PatientID').val()
	if (PatientID!=""){
		//加载患者基本信息
		var ret=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByRowid",PatientID);
		if (ret!=""){
			var RetArry=ret.split("^")
			$("#patNo").prop("innerText",RetArry[1]);
			$("#patName").prop("innerText",RetArry[2]);
			$("#patSex").prop("innerText",RetArry[3]);
			$("#patAge").prop("innerText",RetArry[4]);
			$("#patAge").prop("innerText",RetArry[4]);
			$("#patType").prop("innerText",RetArry[6]);
			$("#patTel").prop("innerText",RetArry[24]);
			$("#patAddress").prop("innerText",RetArry[10]);
		}
	}
	
}

//加载就诊记录信息
function loadAdmDataGrid()
{
	try{
	var PatientID=$('#PatientID').val()
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindAdm';
	queryParams.Arg1 =PatientID;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.ArgCnt =3;
	var opts = cureAdmDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureAdmDataGrid.datagrid('load', queryParams);
	cureAdmDataGrid.datagrid('unselectAll');
	}catch(e){}
}

//初始化DataFride
function IntDataGride(){
	
	// 就诊记录
	cureAdmDataGrid=$('#Admlist').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"PAAdm",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					
					{field:'RowCheck',checkbox:true}, 
					{field:'PAAdm',title:'就诊号',width:100,align:'center',hidden:false},  
					{field:'DCANum',title:'有效预约数',width:100,align:'center',hidden:false},  
        			{field:'Name',title:'姓名',width:100,align:'center'},
        			{field:'PAPMINO',title:'登记号',width:100,align:'center'},
        			{field:'Sex',title:'性别',width:80,align:'center'}, 
        			{field:'Phone',title:'联系电话',width:100,align:'center'}, 
        			{field:'Age',title:'年龄',width:80,align:'center'},   
        			{field:'AdmDate',title:'就诊日期',width:100,align:'center'},
        			{field:'AdmLoc',title:'就诊科室',width:150,align:'center'},
        			{field:'AdmDoc',title:'就诊医生',width:150,align:'center'},
        			{field:'DiaDesc',title:'诊断',width:100,align:'center'},
					{field:'AdmType',title:'就诊类型',width:80,align:'center'},
        			{field:'PatientID',title:'PatientID',width:100,hidden:true}	   
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
			$("#EpisodeID").val(rowData.PAAdm)
			IntPAADMMesage()
		}
	});
	//申请单Grid
	cureApplyDataGrid=$('#Applist').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		//DCARowId:%String,ArcimDesc:%String,OrdStatus:%String,OrdQty:%String,OrdBillUOM:%String,
		//OrdReLoc:%String,OrdReLocId:%String,ApplyStatus:%String,ApplyUser:%String,
		//ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,
		//ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,ApplyRemarks:%String,
		//ApplyPlan:%String,Adm:%String,AppLoc:%String,InsertDate:%String,InsertTime:%String,DocCurNO:%String
		columns :[[ 
					{field:'RowCheck',checkbox:true}, 
					{field:'Adm',title:'就诊号',width:100,align:'center'},    
        			{field:'ArcimDesc',title:'申请名称',width:100,align:'center'},
        			{field:'OrdStatus',title:'申请医嘱状态',width:100,align:'center'},
        			{field:'OrdBillUOM',title:'计价单位',width:150,align:'center'},
        			{field:'OrdReLoc',title:'申请接收科室',width:150,align:'center'},
        			{field:'OrdReLocId',title:'OrdReLocId',width:80,align:'center',hidden:true}, 
        			{field:'ApplyStatus',title:'申请单状态',width:80,align:'center',
        				styler:function(value,row,index){
	        				if (value=="取消"){
		        				return 'color:red'	
		        			}
	        			}
        			}, 
        			{field:'ApplyUser',title:'申请登记人',width:80,align:'center'}, 
        			{field:'AppLoc',title:'申请登记科室',width:100,align:'center'},
        			{field:'ApplyDateTime',title:'申请开始日期',width:80,align:'center'}, 
        			{field:'OrdQty',title:'申请数量',width:80,align:'center'},
        			{field:'ApplyAppedTimes',title:'预约次数',width:80,align:'center'},   
        			{field:'ApplyNoAppTimes',title:'剩余次数',width:100,align:'center'},
        			{field:'ApplyFinishTimes',title:'已治疗次数',width:100,align:'center'},
        			{field:'ApplyNoFinishTimes',title:'未治疗次数',width:100,align:'center'},
        			{field:'ApplyRemarks',title:'申请单备注',width:100,align:'center'},
        			{field:'ApplyPlan',title:'治疗计划',width:100,align:'center'},
        			{field:'InsertDate',title:'登记日期',width:100,align:'center'},
        			{field:'InsertTime',title:'登记时间',width:100,align:'center'},
        			{field:'DocCurNO',title:'申请编号',width:150,align:'center'},
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true}	   
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
			if (SelectApplyData==rowIndex){
				SelectApplyData="-1"
				$('#DCARowId').val('')
				$(this).datagrid('unselectRow',rowIndex)
				
			}else{
				SelectApplyData=rowIndex
				$('#DCARowId').val(rowData.DCARowId)
				IntDCAMesage()
			}
			
			//alert()
			//loadTabData()
		}
	});
}