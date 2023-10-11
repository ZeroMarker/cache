/**
 * FileName: dhcbill\dc\checkresultdetails.js
 * Author: zhangjb
 * Date: 2022-06-28
 * Description: 数据核查结果明细弹窗
 */

var GV = {
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl",
	ParentID:"",
	HosID:"",
	OneAudit:"",
	//Total:"",
	IndicatorCode:"",
	IndicatorId:"",
	QueryType:"1" //1正常查询，2反向查询
};
var ColData=[];
var PageNum="";
$(function() {
	var Rq = INSUGetRequest();
	GV.ParentID = Rq["ParentID"];
	GV.HosID=Rq["HosID"];
	GV.OneAudit=Rq["OneAudit"];
	//GV.Total=Rq["Total"];
	GV.IndicatorId=Rq["IndicatorId"];
	GV.IndicatorCode=Rq["IndicatorCode"];
	$('#OneAudit').linkbutton({disabled:true});
	if (GV.OneAudit=="Y")
	{
		//$('#OneAudit').css('display','block');
		$('#OneAudit').linkbutton({disabled:false});
		//var csse=$('#OneAudit').css('width');
		//$('#ClossWin').css('width',$('#OneAudit').css('width'));
	}
	$("#search1").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			//loadConfPage();
			
			GetLoadDataDialog('1');
		}
	});
	try
	{
		$("#IndexDesc").popover({
			trigger:'hover',
			width:600,
			content:tkMakeServerCall("BILL.DC.BL.IndicatorDefCtl","GetIndiInfo",GV.HosID,'Y',GV.IndicatorId,GV.IndicatorCode,"6")
		});
	}
	catch(err){
		$.messager.alert('提示','获取监控点说明异常：'+err.message,'info');
	}
	GetColHandle();
	//init_ckDetDG();
	GetLoadDataDialog('1');
	$('#AuditDemo').change(function(){
		if(getValueById('AuditDemo').length>500)
		{
			$.messager.alert('提示','审核备注字数超500字。','info');
			//return;
		}
	})
});

function init_ckDetDG(){
	$HUI.datagrid("#ckDet", {
		fit: true,
		//url: $URL,
		border: false,
		singleSelect: false,
		pagination: true,
		pageSize: 30,
		pageList:[15,30,45],
		toolbar: '#dgTB',
		idField: 'Rowid',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [
		ColData
		/* [
			{field:'ck',title:'审核',width:65,align:'center',checkbox:true},
			{title: '异常信息', field: 'ErrConfInfo', width: 300,showTip:true},
			{title: '错误信息', field: 'ErrInfo', width: 400,showTip:true},
			{title: 'ParID', field: 'ParID', hidden: true},
			{title: 'Rowid', field: 'Rowid', hidden: true},
			{title: '表名称', field: 'DataSrc', width: 180},
			{title: '表ID', field: 'DataID', width: 90},
		    {title: '错误代码', field: 'ErrCode', width: 100},
		    //{title: '就诊号', field: 'PAADM', width: 90},
		    {title: '收费类型', field: 'ChargeType', width: 90},
		    {title: 'ParNodeDataSrc', field: 'ParNodeDataSrc', width: 70, hidden: true},
		    {title: 'ParNodeDataID', field: 'ParNodeDataID', width: 90, hidden: true},
		    {title: 'ParNodeFlag', field: 'ParNodeFlag', width: 70, hidden: true},
		    {title: '审核标志', field: 'CheckFlag', width: 100,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
			}
		    },
		    {title: '审核备注', field: 'UPDTDemo', width: 90,showTip:true},
		   
		    {title: '审核日期', field: 'UPDTDATE', width: 90,
			formatter: function (value, row, index) {
				return (row.CheckFlag == "Y") ? value : "";
			}},
		    {title: '审核时间', field: 'UPDTTIME', width: 90,
			formatter: function (value, row, index) {
				return (row.CheckFlag == "Y") ? value : "";
			}}
			]  */
		],
		onBeforeLoad: function(param) {
			/* param.ClassName=GV.CKRDCLASSNAME;
			param.QueryName="QueryInfo";
			param.ParentID=GV.ParentID;
			param.QueryType=GV.QueryType;
			param.KeyCode=getValueById('search1');
			param.BeginNum=((param.page-1)*param.rows)+1;
			param.EndNum=(param.page*param.rows);
			param.PCheckFlag=(getValueById('CheckFlag')?"Y":"N"); */
			//ClearGrid("ckDet");
		 	PageNum=param.page;
		 	GV.QueryType=(getValueById('InKey')?"1":"2");
			var options=$('#ckDet').datagrid('getPager').data('pagination').options;
			var PageNum=options.pageNumber;
			var PageSize=options.pageSize;
			$.cm({
				ClassName: GV.CKRDCLASSNAME,
					QueryName: "QueryInfo",
					ParentID: GV.ParentID,
					QueryType:GV.QueryType,
					IndexCode:GV.IndicatorId+GV.IndicatorCode,
					KeyCode:getValueById('search1'),
					BeginNum:((param.page-1)*param.rows)+1,
					EndNum:(param.page*param.rows),
					PCheckFlag:(getValueById('CheckFlag')?"Y":"N")
					
			},function(txtData){
				var Data0=txtData.rows[0];
				txtData.rows.splice(0,1);//去第一个元素
			 	txtData.total=txtData.rows[txtData.rows.length-1].TotalNum;
				txtData.curPage=PageNum;
				txtData.rows.splice(txtData.rows.length-1,1);//去最后一个元素
				$('#ckDet').datagrid('loadData',txtData); 
			
			});   
		},
	 	onLoadSuccess: function(data) {
		 	//data.total=GV.Total;
		},
		onDblClickRow: function(rowIndex, rowData){
			ShowDataDetails(rowData)
		},
		onDblClickHeader:function(){
			ShowColEditForm();
		},
		onSelect: function(index, row) {
		} 
	});
	//setTimeout$('#ckDet').datagrid('getPager').data("pagination").options.total=999;
}

function GetColHandle(){
/* 	$.cm({
			ClassName: "BILL.DC.BL.DicDataCtl",
			QueryName: 'QueryInfo',
			HospID : "2",
			KeyCode:"",
			PDicType:"CKDETCol"
	
		},function(txtData){
			if(txtData.total>0){
				
			}
	}); */
	//同步调用
	var jsonData=$cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
			QueryName: 'QueryInfo',
			HospID : "2",
			KeyCode:"",
			PDicType:"CKDETCol"
	},false);
	if (jsonData.total>0){
		//排序
		jsonData.rows.sort(function(a,b){
			return (parseInt(a.ConDesc)-parseInt(b.ConDesc));
		});
		
		ColData = new Array(jsonData.total); //创建相同长度数组
		
		$.each(jsonData.rows,function(index,val){
			
			if(val.DicDemo!="")
			{
				var colobj=$.parseJSON(val.DicDemo)
				if(val.ConCode!=undefined&&val.ConCode!="")//&&val.ConDemo=='SYS')
				{
					var Colfield=colobj.field
					colobj.formatter= eval("(true&&"+val.ConCode+")");
				}
				/* if(colobj.field=='CheckFlag')
				{
					colobj.formatter= eval("(true&&"+val.ConCode+")");
					//colobj.formatter= function (value, row) {
					//	return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
					//}
				}
				if (colobj.field=='UPDTDATE' || colobj.field=='UPDTTIME')
				{
					colobj.formatter= function (value, row) {
						return (row.CheckFlag == "Y") ? value : "";
					}
				}
				*/
				/* if(val.ConDemo=='USER')
				{	
					var Colfield=colobj.field
					colobj.formatter= function (value, row) {
						return getValFormatter(value, row,Colfield);
						var tmpVal = (4)>row.FormatterInfo.split(String.fromCharCode(2)).length?"":row.FormatterInfo.split(String.fromCharCode(2))[4];
						if(tmpVal!="")
						{
							var ValObj=$.parseJSON(tmpVal);
							var GetValue="";
							for (var i in ValObj)
							{
								if (i==colobj.field)
								{
									GetValue=ValObj[i];
									break;
								}
							}
							if (GetValue!="")
							{
								return GetValue;
							}
							else
							{return "";}
						}
						else
						{return "";} 
					}; 
				} */
				//有json串里的hidden控制
			/* 	if (val.ActiveFlag!="Y")
				{
					colobj.hidden=true;
				}
				else
				{
					colobj.hidden=false;
				} */
				if(val.ConDesc!=""&&val.ConDesc>0)
				{
					//ColData.splice((val.ConDesc-1),0,colobj);
					if(index==(val.ConDesc-1))
					{
						ColData[val.ConDesc-1]=colobj;
					}
					else
					{
						ColData[index]=colobj;
					}
				}
				else
				{
					ColData.push(colobj);
				}
			}
			
		});
	}else{
		$.messager.alert('提示','未配置列','error');	
	}
	if(ColData.total>0) 
	{}
}

function getValFormatter(value, row,Colfield){
	var tmpVal = (4)>row.FormatterInfo.split(String.fromCharCode(2)).length?"":row.FormatterInfo.split(String.fromCharCode(2))[4];
	if(tmpVal!="")
	{
		var ValObj=$.parseJSON(tmpVal);
		var GetValue="";
		for (var i in ValObj)
		{
			if (i==Colfield)
			{
				GetValue=ValObj[i];
				break;
			}
		}
		if (GetValue!="")
		{
			return GetValue;
		}
		else
		{return "";}
	}
	else
	{return "";}
					
}

//加载指标明细数据
function GetLoadDataDialog(idtype){
	/*var jsonData="{}";
	var title=jsonData[0];
	var titleArr=[];
	var oldCol=$('#ckDet').datagrid('options').columns;
	
	$.each(title.split(','),function(index,val){
		oldCol.push() 
	})
	$('#ckDet').datagrid('options').columns=oldCol;
	*/
	//$('.pagination-num').attr('value')='1';
	
	if(getValueById('CheckFlag'))
	{
		$('#btnAudit').linkbutton({disabled:true});
		$('#btnReCheckIndex').linkbutton({disabled:false});
	}
	else
	{
		$('#btnAudit').linkbutton({disabled:false});
		$('#btnReCheckIndex').linkbutton({disabled:true});
	}
	init_ckDetDG();
	GV.QueryType=(getValueById('InKey')?"1":"2");//idtype;
	ClearGrid("ckDet");
	PageNum='1';//$('.pagination-num').attr('value');
	var options=$('#ckDet').datagrid('getPager').data('pagination').options;
	//var PageNum=options.pageNumber;
	var PageSize=options.pageSize;
	$.cm({
			ClassName: GV.CKRDCLASSNAME,
			QueryName: "QueryInfo",
			ParentID: GV.ParentID,
			QueryType:GV.QueryType,
			IndexCode:GV.IndicatorId+GV.IndicatorCode,
			KeyCode:getValueById('search1'),
			BeginNum:((PageNum-1)*PageSize)+1,
			EndNum:(PageNum*PageSize),
			PCheckFlag:(getValueById('CheckFlag')?"Y":"N")
	
		},function(txtData){
			/* var oldCol=$('#ckDet').datagrid('options').columns;
			if(txtData.rows.length>2)
			{
				if(txtData.rows[1].PAADM!="")
				{
					var CHarPAADM='{"title": "就诊号", "field": "PAADM", "width": "90"}';
					var PAADMobj=$.parseJSON(CHarPAADM);
					oldCol[0].splice(8,0,PAADMobj);
					
				}
			}
		
			var Data0=txtData.rows[0].Col;
			if (Data0 !=undefined && Data0 !=""){
				$.each(Data0.split('&'),function(index,val){
					var ColPosition="";
					var ColIndex="";
					if(val.indexOf('#') != -1)
					{
						ColPosition=val.split('#')[0];
						ColIndex=val.split('#')[1];
					}
					else
					{
						ColIndex=val;
					}
					var tmpPbj = $.parseJSON(ColIndex);
						tmpPbj.formatter= function (value, row) {
							var tmpVal = (index+3)>row.FormatterInfo.split(String.fromCharCode(2)).length?"":row.FormatterInfo.split(String.fromCharCode(2))[index+3];
							return tmpVal;
						}
					if (ColPosition!="")
					{
						oldCol[0].splice(ColPosition,0,tmpPbj);
					}
					else
					{
						oldCol[0].push(tmpPbj);
					}
				});
			} */
			//$('#ckDet').datagrid('options').columns=oldCol;
			//txtData.rows.splice(0,1);//去第一个元素
			txtData.total=txtData.rows[txtData.rows.length-1].TotalNum;
			txtData.curPage=PageNum;
			txtData.rows.splice(txtData.rows.length-1,1);//去最后一个元素
			//var datastr=txtData.rows[0].FormatterInfo.split(String.fromCharCode(2));
			//$('#ckDet').datagrid(oldCol); 
			$('#ckDet').datagrid('loadData',txtData); 
			//$('#ckDet').datagrid({columns:[oldCol]}); 
			//$('#ckDet').datagrid('loadData',txtData); 
			
	});   
	/* init_ckDetDG();
	return;
	var options=$('#ckDet').datagrid('getPager').data('pagination').options;
	var PageNum=options.pageNumber;
	var PageSize=options.pageSize;
	var queryParams = {
					ClassName: GV.CKRDCLASSNAME,
					QueryName: "QueryInfo",
					ParentID: GV.ParentID,
					KeyCode:getValueById('search1'),
					PCheckFlag:(getValueById('CheckFlag')?"Y":"N")
		};
	loadDataGridStore("ckDet", queryParams); */
}
//双击表头弹框
function ShowColEditForm(){
	var setwidth=window.document.body.clientWidth*0.7;
	var setheigth = window.document.body.clientHeight*0.9;
	var url = "dhcbill.dc.resultdetailscolumnedit.csp"; 
	websys_showModal({
				url: url,
				title: "表头编辑",
				iconCls: "icon-w-edit",
				width: setwidth,
				height: setheigth,
				top: 102,
				left: 326,
				onClose: function()
				{
					GetColHandle();
					GetLoadDataDialog('1');
				}
				
	});
}

//双击显示弹框展示指标明细内容
function ShowDataDetails(rowData){
	setValueById('SErrInfo',rowData.ErrConfInfo+"\r\n"+rowData.ErrInfo);
	
	setValueById('STarName',getValFormatter("", rowData,"User.DHCTarItem||TARIDesc"));
	setValueById('SDataSrc',rowData.DataSrc);
	
	setValueById('STarId',rowData.TarId);
	setValueById('SDataID',rowData.DataID);
	setValueById('SErrCode',rowData.ErrCode);
	
	setValueById('SPatID',getValFormatter("", rowData,"User.PAPatMas||PAPMINo"));
	setValueById('SChargeType',rowData.ChargeType);
	setValueById('SInvSta',getValFormatter("", rowData,"User.DHCINVPRT||PRTFlag")); //"User.DHCPatientBill||PBPayedFlag"
	
	setValueById('SUPDTID',rowData.UPDTID);
	setValueById('SUPDTDATE',rowData.CheckFlag=="Y"?rowData.UPDTDATE:"");
	setValueById('SCheckFlag',rowData.CheckFlag=="Y"?"是":"否");
	
	setValueById('SUPDTDemo',rowData.UPDTDemo);
	setValueById('SUPDTTIME',rowData.CheckFlag=="Y"?rowData.UPDTTIME:"");
	
	$('#DatadetailedForm').dialog({
             //title: '增加',
             iconCls: 'icon-w-edit',
             modal: true,
			 left: 179,
			 top: 99,
         }).dialog('open')
}

function ShowErrorMsg(val)
{
	$.messager.alert('详细信息',val,'info');
}

function serverToHtml(str) {
	return str.toString().replace(/<br\/>/g, "\r\n").replace(/&nbsp;/g, " ");
}

function htmlToServer(str) {
	return str.toString().replace(/(\r)*\n/g, "<br/>").replace(/\s/g, "&nbsp;");
}

//审核
function Audit(){
	var ckRows =  $('#ckDet').datagrid('getChecked');
	if (ckRows.length==0){
		$.messager.alert('提示','请勾选需要审核的错误项。','info');
		return;
	}
	if(getValueById('AuditDemo').length>500)
	{
		$.messager.alert('提示','审核备注字数超500字。','info');
		return;
	}
	$.messager.confirm('提示','是否继续操作' + ckRows.length + '条数据？',function(r){
		if(r){
			var getRows = $('#ckDet').datagrid('getRows');
			var rtn=-1;
			for (var i=0;i<getRows.length;i++){
				var row = getRows[i];
				var rowid = row['Rowid'];
				var ck = DCDataGrid.getCellVal('ckDet',i,'ck');
				ck = ck?"Y":"N";
				if(ck=="N")
				{
					continue;
				}
				var UPDTDemo=getValueById('AuditDemo')||"无";
				var JsonObj = {"CheckFlag":ck,"UpdtDemo":UPDTDemo,"UpdtId":session['LOGON.USERNAME']}
				var jsonStr= JSON.stringify(JsonObj)
				rtn = tkMakeServerCall("BILL.DC.BL.CheckResultDetCtl","UpdaeByJson",jsonStr,rowid);
				if(rtn!='0')
				{
					break;
				}
			}
			if(rtn!='0')
			{
				$.messager.alert('提示','审核失败，备注字数超500字。','info');
			}
			else
			{	
				$.messager.alert('提示','审核成功','info');
			}
			//loadConfPage();	
			GetLoadDataDialog('1');	
			
			UpdateCheckResultFlag();
		}
	});
	
}

//撤销审核
function CancelAudit(){
	var ckRows =  $('#ckDet').datagrid('getChecked');
	if (ckRows.length==0){
		$.messager.alert('提示','请勾选需要撤销审核的错误项。','info');
		return;
	}
	if(getValueById('AuditDemo').length>500)
	{
		$.messager.alert('提示','审核备注字数超500字。','info');
		return;
	}
	$.messager.confirm('提示','是否继续操作' + ckRows.length + '条数据？',function(r){
		if(r){
			var getRows = $('#ckDet').datagrid('getRows');
			var rtn=-1;
			for (var i=0;i<getRows.length;i++){
				var row = getRows[i];
				var rowid = row['Rowid'];
				var ck = DCDataGrid.getCellVal('ckDet',i,'ck');
				ck = ck?"N":"Y";
				if(ck=="Y")
				{
					continue;
				}
				var UPDTDemo=getValueById('AuditDemo')||"无";
				var JsonObj = {"CheckFlag":ck,"UpdtDemo":UPDTDemo,"UpdtId":""} //撤销审核不传 session['LOGON.USERNAME']
				var jsonStr= JSON.stringify(JsonObj)
				rtn = tkMakeServerCall("BILL.DC.BL.CheckResultDetCtl","UpdaeByJson",jsonStr,rowid);
			}	
			if(rtn!='0')
			{
				$.messager.alert('提示','撤销审核失败，备注字数超500字。','info');
			}
			else
			{	
				$.messager.alert('提示','撤销审核成功','info');
			}
			
			//loadConfPage();	
			GetLoadDataDialog('1');	
			UpdateCheckResultFlag();
		}
	});
	
}
//zjb add 更新BILL.DC.PO.CheckResult审核状态
function UpdateCheckResultFlag()
{
	$.cm({
			ClassName: "BILL.DC.BL.CheckResultCtl",
			MethodName: 'UpdateCheckResultCheckFlag',
			ParID:GV.ParentID
		},function(txtData){
			//if(txtData=="0"){
				//$.messager.alert('提示','CheckResultCheckFlag更新成功','info');
			//}
	});
}

//保存为免审记录
function DoOneAudit(){
	//var getRows= $('#ckDet').datagrid('getData').rows;
	var getRows = $('#ckDet').datagrid('getChecked');
	if (getRows.length==0){
		$.messager.alert('提示','请勾选需要免审的错误项。','info');
		return;
	}
	$.messager.confirm('提示','是否一键保存为免审共' + getRows.length + '条数据？',function(r){
		if(r){
			var TarIdList="&";
			for (var i=0;i<getRows.length;i++){
				var row = getRows[i];
				if (row.TarId !="" && TarIdList.indexOf('&'+row.TarId+'&') == -1)//过滤重复就诊号
				{
					TarIdList=TarIdList+row.TarId+"&";
					var saveinfo="^"+GV.IndicatorId+"||"+GV.IndicatorCode+"^TarItem^无^^"+row.TarId+"^"; //CT||04
					saveinfo=saveinfo+"^N^"+GV.HosID;
					saveinfo=saveinfo.replace(/请输入信息/g,"")
					var savecode=tkMakeServerCall("BILL.DC.BL.UnAuditItmCtl","Save",saveinfo,session['LOGON.USERNAME']);
				}
			}	
			$.messager.alert('提示','保存成功。','info');
			//loadConfPage();	
			GetLoadDataDialog('1');	
		}
	});
}
//重新核查
function ReCheckIndex()
{
	$.messager.confirm('提示','是否重新核查？',function(r){
		if(r){
			$.messager.popover({
				msg: '正在核查,请耐心等候！',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
			
			$('#btnReCheckIndex').linkbutton({disabled:true});
			$.cm({
				ClassName:"BILL.DC.Check",
				MethodName:"Check",
				StartDate:"",
				EndDate:"",
				StartTime:"",
				EndTime:"",
				CheckType:"",
				HospDr:"",
				CheckMode:"",
				IndicatorCodeStr:"",
				UserId:"",
				OldCKResultID:GV.ParentID,
				dataType:'text'
			},function(txtData){
				//$('#btnReCheckIndex').linkbutton({disabled:false});		
				if (txtData==""){
					$.messager.alert('提示','核查成功','info');
				}else{
					$.messager.alert('警告',txtData,'info');
				}
				GetLoadDataDialog('1');	
			}); 
		}
	});
}

//账单重新计费
function DoBill()
{
	var choRows =  $('#ckDet').datagrid('getChecked');
	if (choRows.length==0){
		$.messager.alert('提示','请勾选需要重新计费的项。','info');
		return;
	}
	$.messager.confirm('提示','是否账单重新计费，共' + choRows.length + '条数据？',function(r){
		if(r){
			$('#btnDoBill').linkbutton({disabled:true});
			var PAMList="&";
			for (var i=0;i<choRows.length;i++){
				var row = choRows[i];
				if (row.PAADM !="" && PAMList.indexOf('&'+row.PAADM+'&') == -1)//过滤重复就诊号
				{
					PAMList=PAMList+row.PAADM+"&";
					var resBilln=tkMakeServerCall("web.UDHCJFBILL","BILLN",row.PAADM,'1');
					if (resBilln == '0')
					{
						$.messager.alert('提示','就诊号：'+row.PAADM+'账单重新计费成功。','info');
					}
					else
					{
						$.messager.alert('提示','就诊号：'+row.PAADM+'账单重新计费失败：'+resBilln,'info');
					}
				}
			}
			//$('#btnDoBill').linkbutton({disabled:false});
			GetLoadDataDialog('1');	
		}
	});
}

function CloseThisWin()
{
	$.messager.confirm('提示','确定关闭此界面吗？',function(r){
		if(r){
			websys_showModal('close');
		}
	}); 
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
/**
 * 根据入参获取对应grid的对象
 * @method loadDataGridStore
 * @param {String} gridIndex 表格序号 gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} 要获取指定表格的哪个对象/值【tr,td,field,td-div,tdHead,td】
 * @author tangzf
 */
 // DCDataGrid.setValueToEditor
var DCDataGrid={ 
	setGridVal:function(gridId,index,field,val){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
	    var td = $(GridView2).find('.datagrid-body td[field="' + field + '"]')[index];
		var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: field
                });
            if (editor != null) {
                this.setValueToEditor(gridId, index,field,val);
            } else {
		        tmpdiv = $(td).find('div')[0];
		        if(tmpdiv){
			    	tmpdiv.innertText = val;
			    }
				$(tmpdiv).text(val);
            }
        }
	},
	//设置datagrid的编辑器的值 可以使用setGridVal 进行赋值
    setValueToEditor: function (dg,index,field, value) {
	    var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
        switch (editor.type) {
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        case 'switchbox':
            editor.target.switchbox("setValue", value);
            break;
        default:
            editor.html = value;
            editor.target[0].value = value; 
            break;
        }
    },
    // 获取编辑框的值
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // 编辑器的值
	        switch (editor.type) {
	        case 'combobox':
	            rtn = editor.target.combobox('getValue');
	            break;
	        case 'combotree':
	            rtn = editor.target.combotree('getValue');
	            break;
	        case 'textbox':
	            rtn = editor.target.textbox('getValue');
	            break;
	        case 'numberbox':
	            rtn = editor.target.numberbox("getValue");
	            break;
	        case 'datebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'datetimebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'switchbox':
	            rtn = editor.target.switchbox("getValue");
	            break;
	        case 'combogrid':
	            rtn = editor.target.combobox('getValue');
	            break;
	        default:
	            rtn = editor.target[0].value ; 
	            break;
	        }
		}else{ // 非编辑器的
			var rows = $('#' + dg).datagrid('getRows');
			rtn = rows[index][field];
			var gridViewArr = $('#' + dg).siblings();
			var GridView2 = '';
			for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
				var GridClass = $(gridViewArr[gridIndex]).attr('class');
				if(GridClass.indexOf('view2') > 0){
					GridView2 = gridViewArr[gridIndex];		
				}
			}
		    var view = GridView2;
			// 
			var Field = $(view).find('.datagrid-body td[field="' + field + '"]')[index];
			var divObj = $(Field).find('div')[0];
			var jObj = $(divObj).children(":first");
			var result = '';
			if(!jObj || (jObj && jObj.length == 0)){
				result = divObj.innerText; 
			}
	        else if (jObj[0].tagName=="INPUT"){
				var objType=jObj.prop("type");
				var objClassInfo=jObj.prop("class");
				if (objType=="checkbox"){
					//result=jObj.is(':checked')
					result = jObj.checkbox("getValue");
				}else if (objType=="select-one"){
					result=jObj.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result=jObj.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result=jObj.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result=jObj.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result=jObj.numberbox("getValue");
					}
				}
			}else if(jObj[0].tagName=="SELECT"){
				var objClassInfo=jObj.prop("class");
				if (objClassInfo.indexOf("combogrid")>=0){
					result=jObj.combogrid("getText");
				}else if (objClassInfo.indexOf("combobox")>=0){
					result=jObj.combobox("getValue");
				}
			}else if(jObj[0].tagName=="LABEL"){
				result = jObj.text();
				
			}else if(jObj[0].tagName=="A"){  //按钮修改显示值 2018-07-23 
				result = jObj.find(".l-btn-text").text();
			}else if(jObj[0].tagName=="TABLE"){  // editor
				var editInput = $(jObj).find('input');
				var objType=editInput.prop("type");
				var objClassInfo=editInput.prop("class");
				if (objType=="checkbox"){
					result = editInput.checkbox("getValue");
				}else if (objType=="select-one"){
					result=editInput.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result = editInput.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result = editInput.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result = editInput.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result = editInput.numberbox("getValue");
					}else{
						result = editInput[0].value; 	
					}
				}
			}
	        rtn = result;	
		}
        return rtn;
    },
    // 表格对象
    getTableObj:function(grid,index,type){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
    	var tr = $(view).find('.datagrid-body tr[datagrid-row-index=' + index + ']');
		switch (type){ // gridIndex 0:pat,1:,2:tar,3:ord
		    case "tr" :
				// 审核人
				rtn = tr;
		    	break;
		    case "tdHead" :  
		    	tr = $(view).find('.datagrid-header-row');  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "td" :  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
			default :
	    		break;
		}
	}
}
