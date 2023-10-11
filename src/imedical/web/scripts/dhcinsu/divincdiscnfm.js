/**
* FillName: divincdiscnfm.js
* Description: 医保清分确认(异地)
* Creator DingSH
* Date: 2021-06-11
*/
// 定义常量
var PUB_CNT = {
	HITYPE:'',                               //医保类型
	SSN: {
		USERID: session['LOGON.USERID'],	//操作员ID
		WARDID: session['LOGON.CTLOCID'],	//科室ID
		CTLOCID: session['LOGON.WARDID'],	//病区ID
		HOSPID: session['LOGON.HOSPID']		//院区ID
	},
	SYSDTFRMT:function(){
		var _sysDateFormat=$.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	     },false);
	     
	     return _sysDateFormat;
		}
};

//入口函数
$(function(){
	setPageLayout();    //设置页面布局
	setElementEvent();	//设置页面元素事件
});

//设置页面布局
function setPageLayout(){
	
	//初始化日期
	initDate();
	//$('#stdate').datebox('setValue',GetLastMDate().split(",")[0]);
    //$('#endate').datebox('setValue',GetLastMDate().split(",")[1]);
	
	//医保类型
	initHiTypeCmb();
	
	//清算记录
	initBallistDg();
	
	//清算明细列表
	InitDivDetDg();
	
	//医保中心异常记录
	initCentererrDg();
	
	//HIS异常记录
	initHiserrDg();
	
	$('#CnfmDlBd').hide();
	
	
}

//设置页面元素事件
function setElementEvent()
{
	 //同步HIS结算数据
    $("#btnSynHisDiv").click(function () {
        SynHisDiv();
    });
	//清分提取+清分数据生成
	 $("#btnDivCreate").click(function () {
        DivCreate();
    });
     
     //清分数据查询
	 $("#btnDivSumQuery").click(function () {
		SetBtnIsDisabled();
        DivSumQuery();
    });
    //清分数据作废(待清分状态)
    $("#btnDivCreateDel").click(function () {
        DivCreateDel();
    });
    
    //清分确认
    $("#btnDivConfirm").click(function () {
        DivConfirm();
    });
    
	//清分回退
    $("#btnDivConfirmCancel").click(function () {
        DivConfirmCancel();
    });
   
	//清分明细确认状态(是否纳入本次清分)更新
    $("#btnUpdtCnfm").click(function () {
        UpdtDivDetCnfm();
    });
    //更新窗体关闭
    $("#btnCnfmDlC").click(function () {
        $('#CnfmDlBd').window('close');
    });
    
     //导出清分明细
     $("#btnDivDetEpot").click(function () {
        btnDivDetEpot();
    });
    
}
//初始化医保类型
function initHiTypeCmb()
{
	$HUI.combobox('#hiType',{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	method:'GET',
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName='web.INSUDicDataCom';
	    	param.QueryName='QueryDic';
	    	param.ResultSetType='array';
	    	param.Type='DLLType';
	    	param.Code='';
	    	param.HospDr=PUB_CNT.SSN.HOSPID;
	    },
	    loadFilter:function(data){
			for(var i in data){
				if(data[i].cDesc=='全部'){
					data.splice(i,1)
				}
			}
			return data
		},
		onSelect:function(rec){
			PUB_CNT.HITYPE=rec.cCode;
		}
	});
}

//初始化对总账结果dg
function initBallistDg()
{
	 $HUI.datagrid('#ballist',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:10,
		pageList:[10, 20, 30],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			
			{field:'clrOptins',title:'经办机构',width:80,hidden:true},
			{field:'xzlb',title:'险种类型',width:150,hidden:true},
			{field:'xzlbDesc',title:'险种类型',width:150,hidden:true},
			{field:'clrType',title:'清算类别',width:80,hidden:true},
			{field:'clrTypeDesc',title:'清算类别',width:80,hidden:true},
			{field:'clrWay',title:'清算方式',width:80,hidden:true},
			{field:'insuType',title:'医保类型',width:100},
			{field:'medfeeSumAmt',title:'总金额',width:100,align:'right'},
			{field:'fundPaySumAmt',title:'基金支付总额',width:100,align:'right'},
			{field:'ybzfPayAmt',title:'账户支付总额',width:100,align:'right'},
			{field:'cashPayAmt',title:'个人自付总额',width:100,align:'right'},
			{field:'fixMedinsSetlCnt',title:'医保总人次',width:100},
			{field:'trtMonth',title:'清算月份',width:100},
			{field:'stmtBegnDate',title:'对账开始日期',width:100},
			{field:'stmtEndDate',title:'对账结束日期',width:100},
			{field:'blFlag',title:'对账标志',width:100,hidden:true},
			{field:'blFlagDesc',title:'对账标志',width:100,width:100/*,
				styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.blFlagDesc)
					    { 
					      case "待清分" :
	    		                rtnStyle= 'background-color:#10B2C8;color:white';
	    		                break;
	                       case "清分确认" :
	    	                     rtnStyle= 'background-color:#1044C8;color:white';
	    	                     break;
	    	              case "清分回退或作废" :
	    	                     rtnStyle= 'background-color:#EE4F38;color:white';
	    	                     break;  
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }
							
					return rtnStyle
				}*/},
			{field:'blDate',title:'对账日期',width:100},
			{field:'blTime',title:'对账时间',width:120},
			{field:'blUser',title:'对账人',width:120},
			{field:'optDate',title:'操作日期',width:80},
			{field:'optTime',title:'操作时间',width:120},
			{field:'optUser',title:'操作人',width:80},
			{field:'stmtRslt',title:'对账结果',width:80},
			{field:'stmtRsltDscr',title:'对账结果说明',width:100},
			{field:'hospId',title:'hospId',width:80,hidden:true},
			{field:'zStr01',title:'业务类型',width:80},
			{field:'zStr02',title:'退费标识',width:80},
			{field:'Rowid',title:'DivSumDr',width:100}
		]],
		onLoadSuccess:function(data){
			var t=data.total||0;
			if (t>0){
			   $('#ballist').datagrid('selectRow', 0);
			}

		},
        onSelect:function(rowIndex, rowData) {
            DivDetQuery();
            DivUnusualQuery(rowData.Rowid);
            SetBtnIsDisabled(rowData.blFlagDesc);
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onDblClickRow:function(rowIndex,rowData){
				
		}
	});

}





//设置按钮是否可用
function SetBtnIsDisabled(blFlagDesc)
{
	switch (blFlagDesc)
	    { 
	      case "待清分" :
                enableById("btnDivCreate");         /*清分提取*/
                enableById("btnDivSumQuery");       /*清分查询*/
                enableById("btnDivConfirm");        /*清分确认*/
                enableById("btnSynHisDiv");         /*同步HIS数据*/
                enableById("btnDivCreateDel");      /*清分作废*/
                disableById("btnDivConfirmCancel");   /*清分回退*/
                break;
           case "清分确认" :
                enableById("btnDivCreate");         /*清分提取*/
                enableById("btnDivSumQuery");       /*清分查询*/
                disableById("btnDivConfirm");        /*清分确认*/
                enableById("btnSynHisDiv");         /*同步HIS数据*/
                disableById("btnDivCreateDel");      /*清分作废*/
                enableById("btnDivConfirmCancel");   /*清分回退*/
                break;
          case "清分回退" :
                enableById("btnDivCreate");         /*清分提取*/
                enableById("btnDivSumQuery");       /*清分查询*/
                disableById("btnDivConfirm");        /*清分确认*/
                enableById("btnSynHisDiv");         /*同步HIS数据*/
                disableById("btnDivCreateDel");      /*清分作废*/
                disableById("btnDivConfirmCancel");   /*清分回退*/
                 break;
          case "清分作废" :
                enableById("btnDivCreate");         /*清分提取*/
                enableById("btnDivSumQuery");       /*清分查询*/
                disableById("btnDivConfirm");        /*清分确认*/
                enableById("btnSynHisDiv");         /*同步HIS数据*/
                disableById("btnDivCreateDel");      /*清分作废*/
                disableById("btnDivConfirmCancel");   /*清分回退*/
                break;      
           default :
                enableById("btnDivCreate");         /*清分提取*/
                enableById("btnDivSumQuery");       /*清分查询*/
                disableById("btnDivConfirm");        /*清分确认*/
                enableById("btnSynHisDiv");         /*同步HIS数据*/
                disableById("btnDivCreateDel");      /*清分作废*/
                disableById("btnDivConfirmCancel");   /*清分回退*/
                 break;
         }
}





//初始化医保对明细账结果列表
function InitDivDetDg()
{
	 DivDetDg=$HUI.datagrid('#divdetdg',{
		//iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		checkOnSelect:false,
        singleSelect: true,
         frozenColumns: [[
            {
                field: 'TOpt',
                width: 60,
                title: '操作',
                formatter: function (value, row, index) {
	                var title="'清分确认审核'"
	                var src="'../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png'"
	                var onclk= "initCnfmDlBdFrm('" + index + "')" ;
                    if (row.blFlag == "1"){
	                     title="''"
	                     src="'../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'";
	                     onclk="''";
	                    }
                    return "<img class='myTooltip' style='width:80' title="+title + " onclick=" +onclk + " src=" + src +"style='border:0px;cursor:pointer'>";

                },
                align:'center'
            }

        ]],
		columns:[[
			
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'patNo',title:'登记号',width:100},
			{field:'psnname',title:'姓名',width:80},
			{field:'setlid',title:'单据流水号',width:180},
			{field:'mdtrtid',title:'就诊流水号',width:180},
			{field:'psnno',title:'个人编号',width:180,hidden:true},
			{field:'certno',title:'证件号码',width:180},
			{field:'medfeesumamt',title:'总金额',width:100,align:'right'},
			{field:'fundpaysumamt',title:'基金支付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'cnfmFlagDesc',title:'是否清分',width:100/*,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.cnfmFlag)
					    { 
					      case "1" :
	    		                rtnStyle= 'background-color:#4B991B;color:white';
	    		                break;
	    		           case "0" :
	    		                rtnStyle= 'background-color:#EE4F38;color:white';
	    		                break;    
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}*/},
			{field:'memo',title:'备注',width:150},
			{field:'acctpay',title:'账户支付金额',width:100,align:'right'},
			{field:'psncashpay',title:'个人自付金额',width:100,align:'right'},
			{field:'psncerttype',title:'证件类型',width:80},
			{field:'XzlxDesc',title:'险种类型',width:150},
			{field:'ClrTypeDesc',title:'清算类别',width:100},
			{field:'clroptinsDesc',title:'经办机构',width:80},
			{field:'stmtRslt',title:'对账结果',width:80},
			{field:'refdSetlFlag',title:'退费标志',width:100,hidden:true},
			{field:'blCenterDivDr',title:'CenterDivDr',width:100}
			
		]],
	    onLoadSuccess:function(data){
			
		}
	});
}	



//初始化清分确认标识弹窗
function initCnfmDlBdFrm(rowIndex) {
    //$('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    //$('#RdInsuType').val($("#InsuType").combobox('getValue'));
    var SelRow = $('#divdetdg').datagrid("getRows")[rowIndex];
    //var SelRow = $('#divdetdg').datagrid('getSelected');
	if(!SelRow){
		$.messager.alert('提示','请选择一条记录！','info');
		return;
	}
	setValueById('cDivDetDr',SelRow.Rowid);
    setValueById('cName',SelRow.psnname);
    setValueById('cRegNo',SelRow.patNo);
    setValueById('cBcbxf',SelRow.medfeesumamt);
    setValueById('CJjzfe',SelRow.fundpaysumamt);
    setValueById('cDivDate',SelRow.divDate);
    setValueById('cDivTime',SelRow.divTime);
    if (SelRow.cnfmFlag == "1")
    {
       $HUI.radio("#cIsCnfm1").setValue(true);
    }else
    { 
        $HUI.radio("#cIsCnfm0").setValue(true);
	    
	 }
   
    setValueById('cCnfmBz',SelRow.memo);
    
    setValueById('cCertno',SelRow.certno);
      
    $('#CnfmDlBd').show();
    $HUI.dialog("#CnfmDlBd", {
        title: "清分确认状态审核",
        height: 322,
        width: 532,
        iconCls: 'icon-w-batch-add',
        modal: true
    })

}

//初始化医保中心异常数据
function initCentererrDg()
{
	 centerErrdg=$HUI.datagrid('#centererrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		toolbar: [],
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true },
		    {field:'patNo',title:'登记号',width:100},
		    {field:'patName',title:'姓名',width:100},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'djlsh',title:'结算ID',width:180},
			{field:'zylsh',title:'就诊ID',width:180},
			{field:'hndFlag',title:'处理状态',width:80/*,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.hndFlag)
					    { 
					      case "已冲正" :
	    		                rtnStyle= 'background-color:#1044C8;';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}*/},
			{field:'psnno',title:'个人编号',width:180},
			
			{field:'psnName',title:'就诊姓名',width:100,hidden:true},
			{field:'InsuTotAmt',title:'总金额',width:100,align:'right'},
			{field:'InsuJjzfe',title:'基金支付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'InsuZhzfe',title:'账户支付金额',width:100,align:'right'},
			{field:'InsuGrzfe',title:'个人自付金额',width:100,align:'right'},
			{field:'refdSetlFlag',title:'退费标志',width:100},
			{field:'msgid',title:'发送方交易流水号',width:180},
			{field:'memo',title:'备注',width:200},
			{field:'hndFUser',title:'处理人',width:100},
			{field:'hndDate',title:'处理日期',width:100},
			{field:'hndTime',title:'处理时间',width:100},
			{field:'blCenterDivDr',title:'blCenterDivDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});	
}

//初始化HIS异常数据
function initHiserrDg()
{
	 hisErrdg=$HUI.datagrid('#hiserrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		toolbar: [],
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true},
			{field:'blCenterDivDr',title:'blCenterDivDr',hidden:true},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'patNo',title:'登记号',width:100},
		    {field:'patName',title:'姓名',width:100},
			{field:'djlsh',title:'结算ID',width:180},
			{field:'zylsh',title:'就诊ID',width:180},
			//{field:'psnName',title:'就诊姓名',width:100},
			{field:'psnno',title:'个人编号',width:180},
			{field:'InsuTotAmt',title:'总金额',width:100,align:'right'},
			{field:'InsuJjzfe',title:'基金支付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'InsuZhzfe',title:'账户支付金额',width:100,align:'right'},
			{field:'InsuGrzfe',title:'个人自付金额',width:100,align:'right'},
			{field:'refdSetlFlag',title:'退费标志',width:100},
			{field:'msgid',title:'发送方交易流水号',width:180},
			{field:'memo',title:'备注',width:200},
			{field:'blHisDivDr',title:'blHisDivDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});
}

//查询清分结果
function DivSumQuery()
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx="";
	var ClrType="";
	var Options="";
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！','info');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！','info');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.DivSum'+"&QueryName="+'InsuDivSumQuery'+"&StDate="+StDate+"&EndDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=0"+"&HiType="+hiType +"&RefdSetlFlag=0"+"&SetlOptions="+Options    

	})
}
//清分生成数据作废记录
function DivCreateDel()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条待清分记录！','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if (blFlag!="0"){
		$.messager.alert('提示','非待清算记录，不允许作废！','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	$m({
		ClassName: "INSU.MI.BL.DivIncdisCtl",
		MethodName: "StrikeDivSumById",
		RowId: RowId,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID

 
  
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"作废失败！"+rtn,'info');
		}
		DivSumQuery();
	});
	
}

//查询异常数据
function DivUnusualQuery(DivSumDr)
{
	if(DivSumDr==""){
		return;
	}
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=1";
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=0";
	$HUI.datagrid('#hiserrdg',{
		url:urlStr
	});
	
}

//查询对明细账结果
function DivDetQuery()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条记录！','info');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	if(DivSumDr==""){
		return;
	}
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.DivDet&QueryName=DivDetRsltQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=";
	$HUI.datagrid('#divdetdg',{
		url:urlStr
	});
	
}




//同步HIS医保结算数据
function SynHisDiv() 
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "提示",
		text: '正在同步HIS医保结算数据请稍后....'
	});

	// 提取清分数据
	$m({
		ClassName: "INSU.MI.BL.DivIncdisCtl",
		MethodName: "SynHisDivInfo",
		StDate: StDate,
		EndDate: EndDate,
	    UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		HiType:PUB_CNT.HITYPE,
		HAdmType:'I'
	},function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('提示','同步HIS医保结算数据发生错误！rtn='+rtn,'info');
			return;	
		}
		DivSumQuery();
	});
}



//异地清分提取
function DivCreate() 
{
	SynHisDiv();
	$.messager.progress({
		title: "提示",
		text: '正在提取异地清分数据请稍后....'
	});
	var DivSumDr=""; //提取数据和汇总表指针无关 DingSH 20210615
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=""	//$('#xzlx').combobox('getValue');
	var ClrType=""	//$('#clrType').combobox('getValue');
	var Options=""	//$('#centerno').combobox('getValue');
	
	if (StDate==""||EndDate==""){
		$.messager.alert('提示','请选择开始日期、结束日期!','info');
		return;
	}
	ExpString="^^^"+StDate+"^"+EndDate+"^"+DivSumDr+"^^^^^^^";
	var Flag=InsuDivInfoQuery(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Flag<0){
		$.messager.progress("close");
		$.messager.alert('提示','清分明细提取失败','info');
		//return;
	}
	$.messager.alert('提示','清分明细提取成功','info');
	//清分生成
	CrtDivIncdisCnfmData(function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('提示','生成待清分数据错误！rtn='+rtn,'info');
			return;	
		}
		DivSumQuery();
		});	
	
}
//生成清分数据
/// callBack 回调函数
function CrtDivIncdisCnfmData(callBack)
{
	
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=""	//$('#xzlx').combobox('getValue');
	var ClrType=""	//$('#clrType').combobox('getValue');
	var Options=""	//$('#centerno').combobox('getValue');
	
	 //生成对清分数据
	$m({
		ClassName: 'INSU.MI.BL.DivIncdisCtl',
		MethodName: "CrtDivIncdisCnfmData",
		StDate:StDate,
		EndDate:EndDate ,
		ClrType: '',
		UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		SetlOptions: '',
		HiType:PUB_CNT.HITYPE,
		RefdSetlFlag:'0'
	},function(rtn){
		callBack(rtn);
	});

}

//清分提交
function DivConfirm() 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条记录！','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="0")&&(blFlag!="待清分")){
		$.messager.alert('提示','该记录非待清分状态，不允许重复确认！','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	
	
	ExpString="^^^^^^^^^^"+RowId+"^";
	var Rtn=InsuDivInfoConfirm(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Rtn<0){
			$.messager.alert('提示','清分确认失败','info');
	}else{
			$.messager.alert('提示','清分确认成功','info');
	}
	DivSumQuery();
}

//清分提交回退
function DivConfirmCancel() 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条记录！','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="1")&&(blFlag!="清分确认")){
		$.messager.alert('提示','该记录还未完成清分确认，不能回退！','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	var ExpString="^^^^^^^^^^"+RowId+"^";
	var Rtn=InsuDivInfoConfirmCancel(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Rtn<0){
			$.messager.alert('提示','清分确认回退失败','info');
	}else{
			$.messager.alert('提示','清分确认回退成功','info');
	}
	DivSumQuery();
}






//初始化日期
function initDate(){
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth())+"-"+"01" //date.getDate();
	var s1=date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth()) //date.getDate();
	if (PUB_CNT.SYSDTFRMT()==4)
	{
	 var s0="01" +"/"+(date.getMonth()+"/"+date.getFullYear());
	 var s1=getSpanDays(date.getMonth())+"/"+(date.getMonth()+"/"+date.getFullYear()); //date.getDate()
	}
	
	$('#stdate').datebox({
		value: s0,
	    formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		},
		
		onSelect:function(date){
			var StDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
			var EdDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+(date.getDate()+getSpanDays(date.getMonth()+1)-1);
			if (PUB_CNT.SYSDTFRMT()==4)
	        {
		       StDate=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
	           EdDate=(date.getDate()+getSpanDays(date.getMonth()+1)-1)+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
	        }
			$('#stdate').datebox('setValue',StDate);
			$('#endate').datebox('setValue',EdDate);
		}
	});
	
	$('#endate').datebox({
		value: s1,
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
			
		}
	});
	
	function getSpanDays(month,year){
		var SpanDays=31;
		if ((month == 4)||(month == 6)||(month == 9)||(month == 11)){
			 SpanDays=30;
			}
		if (month == 2) {
			var tyear=year||(new Date()).getFullYear();
			SpanDays=28;
			if((tyear%4 ==0)&&(tyear%100 !=0)){
				 SpanDays=29;
				}
			}
			
			return SpanDays ;
		
		}

}



///更新清分确认标识
function UpdtDivDetCnfm(){
	
	var DivDetDr=getValueById('cDivDetDr');
	if (DivDetDr == ""){$.messager.alert('提示','请选择一条明细','info');return;}
	var checkedRadioJObj = $("input[name='cIsCnfm']:checked");
	var CnfmFlag=checkedRadioJObj.val();
	
	var Memo=getValueById('cCnfmBz');
	if (Memo == ""){$.messager.alert('提示','清分备注不能为空','info');return;}
	var UserId=PUB_CNT.SSN.USERID;
	var HospId=PUB_CNT.SSN.HOSPID;
	var certno=getValueById('cCertno');
    if (certno == ""){$.messager.alert('提示','证件号码(身份证号)不能为空','info');return;}
	var ExpStr=certno+"^";
	var rtn=tkMakeServerCall("INSU.MI.BL.DivIncdisCtl","UpdtDivDetCnfm",DivDetDr,CnfmFlag,Memo,UserId,HospId,ExpStr);
	if (rtn.split("^")[0]<0){
		
		$.messager.alert('提示','更新失败'+rtn,'info');
		}else{
			
			$.messager.alert('提示','更新成功','info');
			$('#CnfmDlBd').window('close');
			//清分生成
	        CrtDivIncdisCnfmData(function(rtn){
		    if((rtn.split("^")[0])<0){
			 $.messager.alert('提示','生成待清分数据错误！rtn='+rtn,'info');
			 return;	
		    }
		     DivSumQuery();
		    });	
			}
	}
	
	
	//导出清分明细
function btnDivDetEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	DivDetEpot(DivSumDr);
}

//异常数据导出
function DivDetEpot(DivSumDr)
{
	
	var ExcelName="DivDetCnfm"+getExcelFileName()
	
	$.messager.progress({
			   title: "提示",
			   msg: '正在导出清分数据',
			   text: '导出中....'
		   });
		   
		   
    var blFlag="",Celltxt="'"
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.DivDet","DivDetRsltQuery",DivSumDr,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,blFlag,Celltxt);
	if (rtn) location.href = rtn ; 
	setTimeout('$.messager.progress("close");', 3 * 1000);
  

 }
 
 
 function getExcelFileName() {
		var date = new Date();
	    var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		var hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
		var minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
		var second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
		var milliSeconds = date.getMilliseconds();
		var currentTime = year+''+month + '' + day + '' + hour + '' + minute + '' + second + '' + milliSeconds;
		return currentTime;
	}
