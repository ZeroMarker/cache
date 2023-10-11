/**
* FillName: dhcinsu/divmonstmt.js
* Description: 医保对账
* Creator DingSH
* Date: 2021-06-09
*/
// 定义常量
var PUB_CNT = {
	HITYPE:'',                               //医保类型
	REFDSETLFLAG:'1',                        //退费结算标志（为0时，总账对账数据不包含退费数据；为1、空值、null、缺省时，总账对账数据包含退费数据）
	BLMOD:'0',                               //对账模式  1:日对账,其他月对账
	DLALLFLAG:'0',                           //是否可以传空文件下载全部明细1/0
	SSN: {
		USERID: session['LOGON.USERID'],	 //操作员ID
		WARDID: session['LOGON.CTLOCID'],	 //科室ID
		CTLOCID: session['LOGON.WARDID'],	 //病区ID
		HOSPID: session['LOGON.HOSPID']		 //院区ID
	},
	SYSDTFRMT:function(){
		var _sysDateFormat=$.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	     },false);
	     
	     return _sysDateFormat;
		},
		
	BlList:undefined
	
};
var LockFlag = "";
//入口函数
$(function(){
	checkLock();// 判断是否只能查询界面
	GetjsonQueryUrl()
	setPageLayout();    //设置页面布局
	setElementEvent();	//设置页面元素事件
	
});

 //设置页面布局
function setPageLayout(){
	//初始化日期
	initDate();
	//医保类型
	initHiTypeCmb();
	//初始化对账类型 +20230301
	initBlModType();
	//初始化对账状态 +20230301
	initBlStatus();
	//对账结果记录
	initBallistDg();
	//明细列表
	InitDivDetDg();
	//医保中心异常记录
	initCentererrDg();
	//HIS异常记录
	initHiserrDg();
}
//设置页面元素事件
function setElementEvent()
{
	
	 //同步HIS结算数据
    $("#btnSynHisDiv").click(function () {
	     try {
         disableById("btnSynHisDiv");    
         $HUI.linkbutton('#btnSynHisDiv',{stopAllEventOnDisabled:true});   
         SynHisDiv(); 
        } catch (error) {
        
        }finally{
         enableById("btnSynHisDiv");    
          $HUI.linkbutton('#btnSynHisDiv',{stopAllEventOnDisabled:false}); 
        }
           
    });
   
	 /*生成对账数据*/
	 $("#btnDivSumCreate").click(function () {
		  try {
         disableById("btnDivSumCreate");    
         $HUI.linkbutton('#btnDivSumCreate',{stopAllEventOnDisabled:true});   
          DivSumCreate_Click();
        } catch (error) {
        
        }finally{
         enableById("btnDivSumCreate");    
          $HUI.linkbutton('#btnDivSumCreate',{stopAllEventOnDisabled:false}); 
        }
        
       
    });
    
      /*查询*/
	 $("#btnDivSumQuery").click(function () {
        DivSumQuery_click();
    });
   
    /*作废对账数据*/
    $("#btnDivSumCreateDel").click(function () {
        DivSumCreateDel_click();
    });
    
   /*对总账*/
    $("#btnDivSumConfirm").click(function () {
        DivSumConfirm_Click();
    });
    
    /*对明细账*/
    $("#btnDivDetConfirm").click(function () {
        DivDetConfirm_click();
    });
   
    /*清算申请*/
    $("#btnClrAppy").click(function () {
        btnClrAppy_click();
    });
    /*清算申请撤销*/
    $("#btnClrAppyCancel").click(function () {
        btnClrAppyCancel_click();
    });
   
	/*//清分明细确认状态(是否纳入本次清分)更新
    $("#btnUpdtCnfm").click(function () {
        UpdtDivDetCnfm();
    });
    //更新窗体关闭
    $("#btnCnfmDlC").click(function () {
        $('#CnfmDlBd').window('close');
    });*/
    
    
	/*导入医保明细--需要按照规定格式提供数据*/
	$('#btnImportDet').off().on("click",btnImportDet);
	
	/*处理医保中心异常*/
	$('#btnStrikeForInsu').off().on("click",function(){
		var oldCancel = $.messager.defaults.cancel;
			$.messager.defaults.ok = "是";
			$.messager.defaults.cancel = "否";
			$.messager.confirm("重要提示", "请确认是否符合冲正要求?", function (r) {
				if (r) {
					btnStrikeForInsu();
				} else {
					
				}
			});
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.cancel = oldCancel;
		});
     /*处理HIS异常*/
	$('#btnStrikeForHis').off().on("click",btnStrikeForHis);
	/*导入第三方数据ForHIS,适合第三方和医保中心交互这种*/
	$('#btnImportThirdDet').off().on("click",btnImportThirdDet);
	/*导出中心异常*/
	$('#btnCenterErrEpot').off().on("click",btnCenterErrEpot);
	/*导出HIS异常*/
	$('#btnHisErrEpot').off().on("click",btnHisErrEpot);
  
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
			PUB_CNT.HITYPE = rec.cCode;
			//initSetlOptinsCmb();
			initInsutypeCmb();
			initClrTypeCmb();
			initInsuHospCmb();	// +20230301
		},
		 onLoadSuccess:function(){
			$('#hiType').combobox('select','00A');
		}
	});
}

//初始化清算类别
function initClrTypeCmb(){
 $HUI.combobox('#clrType',{   
	    url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('clr_type'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		},
		value: ''
	}); 
}
//初始化清算经办结构
function initSetlOptinsCmb()
{
	$HUI.combobox('#setlOptins',{
		url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('setlOptins'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		}
	});
}
//初始化险种类型
function initInsutypeCmb()
{
	$HUI.combobox('#insutype',{
		url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('insutype'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;
		},
		loadFilter:function(data){
			for(var i in data){
				//if(data[i].cDesc=='全部'){
				//	data.splice(i,1)
				//}
			}
			
			return data
		}
	});
}

//初始化对总账结果dg
function initBallistDg()
{
	PUB_CNT.BlList=$HUI.datagrid('#ballist',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		//singleSelect: true,
		pageSize:100,
		pageList:[10, 30, 100],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
		{title: 'ck', field: 'sck', checkbox: true},
		{field:'fundkey',title:'对账唯一键',width:186},
		{field:'clrOptins',title:'社保经办机构',width:80,hidden:true},
		{field:'clrType',title:'清算类别',width:80,hidden:true},
		{field:'clrTypeDesc',title:'清算类别',width:80},
		{field:'xzlb',title:'险种类型',width:150,hidden:true},
		{field:'xzlbDesc',title:'险种类型',width:150},
		{field:'clrWay',title:'清算方式',width:80,hidden:true},
		{field:'insuType',title:'医保类型',width:80},
		{field:'medfeeSumAmt',title:'总金额',width:100,align:'right'},
		{field:'fundPaySumAmt',title:'基金支付总额',width:100,align:'right'},
		{field:'ybzfPayAmt',title:'账户支付总额',width:100,align:'right'},
		{field:'cashPayAmt',title:'个人自付总额',width:100,align:'right'},
		{field:'fixMedinsSetlCnt',title:'医保总人次',width:100}
		]],
		columns:[[
			{field:'stmtBegnDate',title:'对账开始日期',width:100},
			{field:'stmtEndDate',title:'对账结束日期',width:100},
			{field:'blFlag',title:'对账标志',width:100,hidden:true},
			{field:'blFlagDesc',title:'对账标志',width:100},
			{field:'stmtRslt',title:'对账结果',width:80},
			{field:'stmtRsltDscr',title:'对账结果说明',width:200},
			{field:'blDate',title:'对账日期',width:100},
			{field:'blTime',title:'对账时间',width:100},
			{field:'blUser',title:'对账人',width:100},
			{field:'setlOptins',title:'结算经办机构',width:100},
			{field:'clrAppyStas',title:'清算状态',width:80},
			{field:'clrAppyEvtId',title:'清算事件ID',width:120},
			{field:'clrAppyUser',title:'清算人',width:100},
			{field:'clrAppyDate',title:'清算日期',width:100},
			{field:'clrAppyTime',title:'清算时间',width:100},
			{field:'optDate',title:'操作日期',width:100},
			{field:'optTime',title:'操作时间',width:100},
			{field:'optUser',title:'操作人',width:80},
			{field:'hospId',title:'hospId',width:80,hidden:true},
			{field:'blMod',title:'对账类型',width:80,hidden:true},
			{field:'trtMonth',title:'对账年月',width:80,hidden:true},
			{field:'zStr01',title:'备注',width:80},
			{field:'zStr02',title:'备注',width:100},
			{field:'Rowid',title:'DivSumDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
	        //SetBtnIsDisabled(rowData.blFlagDesc);
            DivUnusualQuery(rowData.Rowid);
            DivDetQuery();
        },
        onClickCell: function (rowIndex, field, value) {
	       ShwBlRsDialog(field, value,rowIndex);
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onLoadSuccess:function(data){
			
			//$(this).datagrid('options').queryParams.qid="0";
		},
		onCheck: function (rowIndex, rowData) {
		if ((rowData.blFlag == "1")||(rowData.blFlag == "3")) {
			    PUB_CNT.BlList.uncheckRow(rowIndex);
			}
		else{
				SetBtnIsDisabled("待对账");
			}
		},
		onCheckAll: function (rows) {
			var Flag=0;
			$.each(rows, function (index, row) {
				if (!row.Rowid) {
					return true;
				}
				if ((row.blFlag == "1")||(row.blFlag == "3")) {
					PUB_CNT.BlList.uncheckRow(index);
					 
				}else{Flag=1}
			});
			
			if (Flag==1){
				   SetBtnIsDisabled("待对账");
				}
			
		}
		
	});

}
//设置按钮是否可用
function SetBtnIsDisabled(blFlagDesc)
{
	switch (blFlagDesc)
	    { 
	      case "待对账" :
                enableById("btnDivSumConfirm");    /*对总账*/
                enableById("btnImportDet");       /*导入医保明细*/
                enableById("btnImportThirdDet");  /*导入第三方明细*/
                enableById("btnDivSumCreateDel"); /*作废对账数据*/
                enableById("btnDivDetConfirm");   /*对明细账*/
                break;
           case "对账成功" :
                disableById("btnDivSumCreate");     /*生成对账数据*/
                disableById("btnDivSumConfirm");    /*对总账*/
                disableById("btnImportDet");        /*导入医保明细*/
                disableById("btnImportThirdDet");   /*导入第三方明细*/
                //disableById("btnDivSumCreateDel");    /*作废对账数据*/
                 enableById("btnDivSumCreateDel");    /*作废对账数据*/
                disableById("btnDivDetConfirm");     /*对明细账*/
                break;
          case "对账失败" :
                enableById("btnDivSumCreate");      /*生成对账数据*/
                enableById("btnDivSumConfirm");    /*对总账*/
                enableById("btnImportDet");        /*导入医保明细*/
                enableById("btnImportThirdDet");    /*导入第三方明细*/
                disableById("btnDivSumCreateDel");  /*作废对账数据*/
                enableById("btnDivDetConfirm");    /*对明细账*/
                 break;
          case "对账作废" :
                enableById("btnDivSumCreate");      /*生成对账数据*/
                disableById("btnDivSumConfirm");    /*对总账*/
                disableById("btnImportDet");        /*导入医保明细*/
                disableById("btnImportThirdDet");   /*导入第三方明细*/
                disableById("btnDivSumCreateDel");  /*作废对账数据*/
                disableById("btnDivDetConfirm");     /*对明细账*/
                break;      
           default :
                enableById("btnDivSumCreate");      /*生成对账数据*/
                disableById("btnDivSumConfirm");    /*对总账*/
                enableById("btnImportDet");         /*导入医保明细*/
                enableById("btnImportThirdDet");    /*导入第三方明细*/
                disableById("btnDivSumCreateDel");  /*作废对账数据*/
                disableById("btnDivDetConfirm");    /*对明细账*/
                 break;
         }
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
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		toolbar:[],
		pagination:true,
		fitColumns:false,
		//Rowid,blDivDetDr,blHisDivDr,blCenterDivDr,InsuType,psnno,InsuTotAmt,InsuJjzfe,InsuZhzfe,InsuGrzfe,djlsh,zylsh,msgid,refdSetlFlag,memo
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true },
		    {field:'patNo',title:'登记号',width:100},
		    {field:'patName',title:'姓名',width:100},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'djlsh',title:'结算ID',width:100},
			{field:'zylsh',title:'就诊ID',width:100},
			{field:'hndFlag',title:'处理状态',width:80,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.hndFlag)
					    { 
					      case "已冲正" :
	    		                rtnStyle= 'background-color:#F58800;color:white';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}},
			{field:'psnno',title:'个人编号',width:180},
			{field:'msgid',title:'发送方交易流水号',width:180},
			{field:'psnName',title:'就诊姓名',width:100,hidden:true},
			{field:'InsuTotAmt',title:'总金额',width:100,align:'right'},
			{field:'InsuJjzfe',title:'基金支付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'InsuZhzfe',title:'账户支付金额',width:100,align:'right'},
			{field:'InsuGrzfe',title:'个人自付金额',width:100,align:'right'},
			{field:'refdSetlFlag',title:'退费标志',width:100},
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
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		toolbar:[],
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
			{field:'djlsh',title:'结算ID',width:100},
			{field:'zylsh',title:'就诊ID',width:100},
			//{field:'psnName',title:'就诊姓名',width:100},
			{field:'psnno',title:'个人编号',width:180},
			{field:'msgid',title:'发送方交易流水号',width:180},
			{field:'InsuTotAmt',title:'总金额',width:100,align:'right'},
			{field:'InsuJjzfe',title:'基金支付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'InsuZhzfe',title:'账户支付金额',width:100,align:'right'},
			{field:'InsuGrzfe',title:'个人自付金额',width:100,align:'right'},
			{field:'refdSetlFlag',title:'退费标志',width:100},
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

//初始化医保对明细账结果列表
function InitDivDetDg()
{
	 DivDetDg=$HUI.datagrid('#divdetdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30,9999],
		data:[],
		toolbar:[],
		pagination:true,
		fitColumns:false,
		checkOnSelect:false,
        singleSelect: true,
        remoteSort: false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'patNo',title:'登记号',width:100},
			{field:'psnname',title:'姓名',width:80},
			{field:'cmprRslt',title:'是否对平', width:100,align:'center',
			formatter: function(value,row,index){
				if (row.blCenterDivDr>0){
					return "是";
				} else {
					return "否";
				 }
			   },
			   /* sorter:function(a,b){  
			
					if (a == b){  
						return 1;  
					} else {  
						return -1;  
					}  
				
			  }*/  
			},
			{field:'setlid',title:'单据流水号',width:180},
			{field:'mdtrtid',title:'就诊流水号',width:180},
			{field:'psnno',title:'个人编号',width:180},
			{field:'medfeesumamt',title:'总金额',width:100,align:'right'},
			{field:'fundpaysumamt',title:'基金支付金额',width:100,align:'right'},
			{field:'acctpay',title:'账户支付金额',width:100,align:'right'},
			{field:'psncashpay',title:'个人自付金额',width:100,align:'right'},
			{field:'divDate',title:'结算日期',width:100},
			{field:'divTime',title:'结算时间',width:100},
			{field:'blFlag',title:'对账状态',width:100,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.blFlag)
					    { 
					      case "0" :
	    		                rtnStyle= 'background-color:#10B2C8;color:white';
	    		                break;
	                       case "1" :
	    	                     rtnStyle= 'background-color:#1044C8;color:white';
	    	                     break;
	    	              case "2" :
	    	                     rtnStyle= 'background-color:#EE4F38;color:white';
	    	                     break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}},
			{field:'msgid',title:'发送方报文ID',width:255},
			{field:'stmtRslt',title:'对账结果',width:80},
			{field:'refdSetlFlag',title:'退费结算标志',width:120},
			{field:'memo',title:'备注',width:150},
			{field:'psncerttype',title:'证件类型',width:80},
			{field:'certno',title:'证件号码',width:180},
			{field:'XzlxDesc',title:'险种类型',width:150},
			{field:'ClrTypeDesc',title:'清算类别',width:100},
			{field:'clroptinsDesc',title:'经办机构',width:80},
			{field:'blCenterDivDr',title:'CenterDivDr',width:100}
			
		]],
	    onLoadSuccess:function(data){
			
		}
	});
}	
//生成对账记录
function DivSumCreate_Click()
{
	
	 var StDate=$('#stdate').datebox('getValue');
	 var EndDate=$('#endate').datebox('getValue');
	 var hiType=$('#hiType').combobox('getValue');
	 var insutype=$('#insutype').combobox('getValue');
	 var ClrType=$('#clrType').combobox('getValue');
	 //var setlOptions=$('#setlOptins').combobox('getValue');
	 var setlOptions=""
	 var blModType=$('#blModType').combobox('getValue');
	 var InsuHospCode=$('#InsuHospCode').combobox('getValue');
	 var blStatus=$('#blStatus').combobox('getValue');
	 
	 if(hiType == ""){
		$.messager.alert('提示','请选择医保类别','info');
	    return;	
	 }
	 //SynHisDiv();  
	 $.messager.progress({
	 	title: "提示",
	 	text: '正在生成对账数据请稍后....'
	 });
	 // BlMod As %String = "", InFundkey As %String = "", ExpStr As %String = ""
	 $m({
	 	ClassName: "INSU.MI.BL.DivMonstmtCtl",
	 	MethodName: "CrtDivMonstmtDataStd",
	 	StDate: StDate,
	 	EndDate: EndDate,
	 	ClrType: ClrType,
	 	Xzlb: insutype,
	 	UserId: PUB_CNT.SSN.USERID,
	 	HospDr: PUB_CNT.SSN.HOSPID,
	 	setlOptions:setlOptions,
 	    HiType:hiType,
	 	RefdSetlFlag:PUB_CNT.REFDSETLFLAG,   //是否包含退费数据：0:不包括
	 	BlMod:blModType,                     //对账类型：0:月对账,1:日对账 PUB_CNT.BLMOD
	 	ExpStr:InsuHospCode+"^"              //扩展串：医保中心端医院代码^
	 },function(rtn){
	 	if(((rtn).split("^"))[0]<0){
	 	    $.messager.alert('提示','生成对账数据发生错误！rtn='+rtn,'info');
	 		$.messager.progress("close");
	 		return;	
	 	}else{
	 		 $.messager.progress("close");
	 		}
	 	//数据生成成功,获取对账主表数据，提交对账
	 	//$.messager.alert('提示','生成对账数据成功!');
	 	$.messager.popover({
	 			msg: '生成对账数据成功!',
	 			type: 'success',
	 			timeout: 2000, 		//0不自动关闭。3000s
	 			showType: 'slide'  
	 		});
	 	DivSumQuery_click();
	 });    
}

//对总账 
function DivSumConfirm_Click()
{
  try
    {
	    var rows= PUB_CNT.BlList.getChecked();
	    if(rows.length<=0){
		      $.messager.alert('提示','请现在对账记录','info');
		      return;
		   }	   
     $.messager.progress({
		title: "提示",
		text: '正在对总账请稍后....'
	 });
	 $.each(rows, function (index, row) {
				 if (!row.Rowid) {
				  	return true;
				 }
					if ((row.blFlag == "0")||(row.blFlag == "2")) {
					 var DivSumDr=row.Rowid;
		             //数据生成成功,获取对账主表数据，提交对账
			         ExpString="^^"+DivSumDr+"^^";
			         var balRtn=InsuLiquidationAll(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
			         /*if(balRtn<0){
				     $.messager.alert('提示','对总账失败');
		         	}else{
			       	$.messager.alert('提示','对总账完毕,请查看对账结果');
			        }*/
					}
				 });
		       DivSumQuery_click();
	   }
   catch(ex)
	      {
		  }
   finally
	     {
		  $.messager.progress("close");
		 }
	
			
	/*
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条记录！');
		return;
	}
	var blFlag=selectedRow.blFlag;
	//if ((blFlag!="0")&&(blFlag!="待对账")&&(blFlag!="对账失败")){
	if ((blFlag=="3")||(blFlag == "对账作废")){
		$.messager.alert('提示','该记录非有效状态,请重新生成对账数据！');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	$.messager.progress({
		title: "提示",
		text: '正在对总账请稍后....'
	});
	  //数据生成成功,获取对账主表数据，提交对账
		ExpString="^^"+DivSumDr+"^^";
		var balRtn=InsuLiquidationAll(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		if(balRtn<0){
			$.messager.alert('提示','对总账失败');
		}else{
			$.messager.alert('提示','对总账完毕,请查看对账结果');
		}
	*/
		

}
//查询对账结果
function DivSumQuery_click()
{
	if(LockFlag != "Y"){
		SetBtnIsDisabled();
	}
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	//var Options=$('#setlOptins').combobox('getValue');
	var Options=""
	
	var BlStas= $('#blStatus').combobox('getValue');
	var BlMod = $('#blModType').combobox('getValue');
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！','info');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！','info');
		return;
	}
	var ExpStr="||";
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.DivSum'+"&QueryName="+'InsuDivSumQuery'+"&StDate="+StDate+"&EndDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+PUB_CNT.REFDSETLFLAG+"&SetlOptions="+Options+"&BlMod="+BlMod+"&BlStas="+BlStas+"&ExpStr="+ExpStr

	})
}

//作废对总账记录
function DivSumCreateDel_click()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条要作废的对账记录！','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	//if ((blFlag!=0)&&(blFlag!="待对账")){
		//$.messager.alert('提示','该记录非对账状态，不允许作废！');
		//return;
	//}
	//
	var RowId=selectedRow.Rowid;
	//if ((blFlag==1)||(blFlag!="对账成功"))
	if ((blFlag==1)||(blFlag=="对账成功"))	//upt HanZH 20220930
	{
	 $.messager.confirm("操作提示", "对账已成功,是否继续作废", function (rtn) {
       if(rtn){
	          _StrikeDivSumById(RowId);
	       }
       });
	}else{
		_StrikeDivSumById(RowId);
		}
}
//作废对账数据
function _StrikeDivSumById(RowId){
	$m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "StrikeDivSumById",
		RowId: RowId,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"作废失败！"+rtn,'info');
		}
		//$.messager.alert('提示',"");
		$.messager.popover({
				msg: '作废成功!',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
		DivSumQuery_click();
		ClearGrid("divdetdg");
	});
	
	}

//对明细账
function DivDetConfirm_click(){
	
	
	each()
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择一条记录！','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag=="3")||(blFlag == "对账作废")){
		$.messager.alert('提示','该记录非有效状态,请重新生成对账数据！','info');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	$.messager.progress({
		title: "提示",
		text: '正在对明细账请稍后....'
	});
	$.messager.confirm("操作提示", "是否重新下载对账明细数据", function (rtn) {
       if(rtn){
		  
		   var ExpString="^^"+DivSumDr+"^"+PUB_CNT.DLALLFLAG+"^"
		  var rtn=InsuLiquidationMx(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		  if(rtn<0){
			$.messager.alert('错误','下载错误','info');
			$.messager.popover({
				msg: '对明细账失败！Err='+rtn,
				type: 'error',
				style: {
					bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
					right: 10
				}
			});
			return;
		  }else{
			//$.messager.alert('提示','对账明细完成');
			$.messager.popover({
				msg: '对账明细完成!',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
		  }
		  //SynRefdStelFlag();
        }
       //SetInsuUnusual(DivSumDr);
       // 如果浏览器 不支持原生的Promise,需要引用插件,详见dhcinsu.divmonstmt.csp 
       var mySynRefdPromise = new Promise(function(resolve, reject){
                  SynRefdStelFlag();
       });
       mySynRefdPromise.then(function(){
           SetInsuUnusual(DivSumDr);
      });
        
	});
	/*
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceDayCtl&QueryName=BalanceDayInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospDr;
	$HUI.datagrid('#ballist',{
		url:urlStr
	});
	*/
}
 /* 清算申请
  *
  *
  */
function btnClrAppy_click () 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择任意一条待清算对账记录！','info');
		return;
	}
	var blMod=selectedRow.blMod;
	if ((blMod!="0"))
	   {
		$.messager.alert('提示','请选择对账成功的月记录！','info');
		return;
	   }
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="1")&&(blFlag!="对账成功"))
	   {
		$.messager.alert('提示','请选择对账成功的记录！','info');
		return;
	   }
	var clrAppyStas=selectedRow.clrAppyStas;
	if ((blFlag=="I")||(blFlag=="已申请"))
	   {
		$.messager.alert('提示','请选择未申请或重新申请的对账记录！','info');
		return;
	   }

	var dHandle = 0 ;
	var setlYM = selectedRow.trtMonth;
	var hiType = selectedRow.insuType;
	var clrType=""; //为空 清算setlYM全部
	var clrWay="";
	var expStr=selectedRow.hospId+"^";
    var rtnFlag = InsuClrAppy(dHandle,PUB_CNT.SSN.USERID,setlYM,hiType,clrType,clrWay,expStr)  //DHCInsuPort.js
    if ((rtnFlag == "0"))
	   {
		$.messager.alert('提示','清算申请成功！','success');
		DivSumQuery_click();
		return;
	   }
      $.messager.alert('提示','清算申请失败：'+rtnFlag,'error');
	  return;  
 }
/*清算申请撤销 
 *
 *
 */
function btnClrAppyCancel_click () 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择任意一条已申请记录！','info');
		return;
	}
	var clrAppyStas=selectedRow.clrAppyStas;
	if ((blFlag!="I")&&(blFlag=!"已申请"))
	   {
		$.messager.alert('提示','请选择已申请状态的记录！','info');
		return;
	   }  
	   
	  $.messager.confirm("重要操作提示", "是否继续撤销清算申请", function (flag) {
       if(flag)
         {
	          
	       	 var dHandle = 0;
			 var hiType = selectedRow.insuType;
			 var clrAppyEvtId=selectedRow.clrAppyEvtId;
			 var clrType = "";
			 var expStr=selectedRow.hospId+"^";
		     var rtnFlag = InsuClrAppyCancel(dHandle,PUB_CNT.SSN.USERID,clrAppyEvtId,hiType,clrType,expStr)  //DHCInsuPort.js  
		      if ((rtnFlag == "0"))
			   {
				$.messager.alert('提示','清算申请撤销成功！','success');
				DivSumQuery_click();
				return;
			   }
		      $.messager.alert('提示','清算申请撤销失败：'+rtnFlag,'error');
			  return;  
	       }
       });    

}  
  
///同步退费结算标识
function SynRefdStelFlag()
{
	
	var EdDate=getValueById('endate');
	var trtMonth=EdDate.split("-")[0]+""+EdDate.split("-")[10];
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynRefdStelFlag",
		trtMonth: trtMonth,
		HospDr:PUB_CNT.SSN.HOSPID,
		HiType: PUB_CNT.HITYPE
	},function(rtn){
		if(rtn.split("^")[0]<0){
			//$.messager.alert('提示',"同步退费结算标识异常："+rtn);
			  $.messager.popover({
				msg: '同步退费结算标识异常："+rtn',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
		}else{
			   //$.messager.alert('提示','同步退费结算标识完成');
			   $.messager.popover({
				msg: '同步退费结算标识完成!',
				type: 'success',
				timeout: 1000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
			   
			}
	  $.messager.progress("close");
	});
}



///对比异常数据
function SetInsuUnusual(DivSumDr)
{
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SetInsuUnusual",
		DivSumDr: DivSumDr,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"同步异常数据错误"+rtn,'info');
		}else{
			   $.messager.alert('提示','同步完成','info');
			}
	  $.messager.progress("close");
	});
}

//查询异常数据
function DivUnusualQuery(DivSumDr)
{
	if(DivSumDr==""){
		return;
	}
	var UrlQry="ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID;
	var urlStr=$URL+"?"+UrlQry+"&blFlag=1"
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	var urlStr=$URL+"?"+UrlQry+"&blFlag=0"
	//var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=0";
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
	var ClrType=$('#clrType').combobox('getValue');
	/*	WangXQ  20221024
	if(ClrType == ""){
		$.messager.alert('提示','清算类别不能为空','info');
		return;
	}*/
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "提示",
		text: '正在同步HIS医保结算数据请稍后....'
	});

	// 提取清分数据
	$m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynHisDivInfo",
		StDate: StDate,
		EndDate: EndDate,
	    UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		HiType:PUB_CNT.HITYPE,
		HAdmType:''
	},function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('提示','同步HIS医保结算数据发生错误！rtn='+rtn,'info');
			return;	
		}else{
			 $.messager.alert('提示','同步HIS医保结算数据成功:'+rtn,'info','info');
			}
		DivSumQuery_click();
	});
}


function initDate(){
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth())+"-"+"01" //date.getDate();
	var s1="" //date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth()) 
	if(PUB_CNT.BLMOD=="1"){s1=s0;}
	else{s1=date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth())}
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
			var EdDate="";
			if(PUB_CNT.BLMOD=="1"){ EdDate=StDate;}
	         else{
		            EdDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+(date.getDate()+getSpanDays(date.getMonth()+1)-1);
		          }
			if (PUB_CNT.SYSDTFRMT()==4)
	        {
		       StDate=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		       if(PUB_CNT.BLMOD=="1"){ EdDate=StDate;}
	           else{
		             EdDate=(date.getDate()+getSpanDays(date.getMonth()+1)-1)+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		            }
	           
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
			
		},
	});
	
	//if(PUB_CNT.BLMOD=="1"){ $('#endate').datebox({disabled: true})}
	
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

function btnImportDet(){

	var selectedRow = $('#ballist').datagrid('getSelected');
	/*if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！');
		return;
	}
	if(selectedRow.blFlag!="待对账"){
		$.messager.alert('提示','非待对账状态不允许第三方明细！');
		return;
	}*/
	var DivSumDr = "",TrtMonth="";
	var trtMonth="";
	if(selectedRow){
	  if((selectedRow.blFlag=="对账作废")||(selectedRow.blFlag=="3")){
		$.messager.alert('提示','请选择一条有效记录','info');
		return;
	}
	  DivSumDr = selectedRow.Rowid ||  "";
	  TrtMonth=selectedRow.trtMonth;
	}
	var BusiType="1";
	
	if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('提示','结束日期不能为空','info');return;}
		var trtMonth=(encdate.slice(0,8)).replace("-","");
	}
	
	if($('#_efinput').length != 0){$('#_efinput').val("");$("#_efinput").empty();$("#_efinput").remove();}
	var inputObj=document.createElement('input')
	inputObj.setAttribute('id','_efinput');
	inputObj.setAttribute('type','file');
	inputObj.setAttribute("style",'visibility:hidden');
	document.body.appendChild(inputObj);
	inputObj.addEventListener("change", 
	function(){
	    var file = inputObj.files[0];
	    if((file==null)||(file==undefined)) return;
	 $.messager.progress({
		title: "提示",
		text: '正在导入医保中心明细数据....'
	});
	    var form = new FormData();
	    form.append("FileStream", file); //第一个参数是后台读取的请求key值
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+"ImporCenterDivInfoFromCSV"+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+TrtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
	            if((res=="0")||(res=="\r\n0")){
		            $.messager.alert('提示','导入完毕！','info');
		        }else{
					$.messager.alert('提示','导入失败: ' + res,'info');   
				}
				$.messager.progress("close");
				DivSumQuery_click();
				
	        }
	    })
	  },false);
	inputObj.click();
}

 //导入第三方HIS数据(适合,第三调用医保接口情况)例如(旧系统数据、自助机、线上医保支付)
function btnImportThirdDet(){
	
	var hiType=$('#hiType').combobox('getValue');
	if(hiType==""){
		$.messager.alert('提示','请先选择医保类别！','info');
		return;
	}
	var selectedRow = $('#ballist').datagrid('getSelected');
	/*if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！');
		return;
	}
	if(selectedRow.blFlag!="待对账"){
		$.messager.alert('提示','非待对账状态不允许第三方明细！');
		return;
	}*/
	var DivSumDr = "",trtMonth="";
	var TrtMonth=""
	var trtMonth=getValueById("endate");
	if(selectedRow){
	  if((selectedRow.blFlag=="对账作废")||(selectedRow.blFlag=="3")){
		$.messager.alert('提示','请选择一条有效记录','info');
		return;
	}
	  DivSumDr = selectedRow.Rowid ||  "";
	  TrtMonth=selectedRow.trtMonth;
	}
	var BusiType="1";
    if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('提示','结束日期不能为空','info');return;}
		var trtMonth=(encdate.slice(0,8)).replace("-","");
	}

	if($('#_efinputThd').length != 0){$('#_efinputThd').val("");$("#_efinputThd").empty();$("#_efinputThd").remove();}
	var inputObj=document.createElement('input')
	inputObj.setAttribute('id','_efinputThd');
	inputObj.setAttribute('type','file');
	inputObj.setAttribute("style",'visibility:hidden');
	document.body.appendChild(inputObj);
	inputObj.addEventListener("change", 
	function(){
	    var file = inputObj.files[0];
	    var filename=file.name
	    //获取最后一个.的位置
		var fileindex= filename.lastIndexOf(".");
		//获取后缀
		var ext = filename.substr(fileindex+1);
	    if(ext!="txt")
	    {
		    $.messager.alert('提示','请导入txt类型文件！','info');
		    return
		    }
	    if((file==null)||(file==undefined)) return;
	    $.messager.progress({
		 title: "提示",
		 text: '正在导入第三方医保数据....'
	    });
	    var form = new FormData();
	    form.append("FileStream", file); //第一个参数是后台读取的请求key值
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+'ImportHisDivInfoFromCSV'+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+TrtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
				$.messager.progress("close");
				DivSumQuery_click();
				var pidNum=res.split("^")
				var pid=pidNum[1]
			   websys_showModal({				//导入弹出界面 WangXQ 20220627
				   url: "dhcinsu.divmonstmtimportresult.csp?&Pid=" + pid,
				   title: "导入记录",
				   iconCls: "icon-w-list",
				   width: "1140",
				   height: "560",
				   onClose: function () {
						kImportDataGlobal(pid);
					}  
		   
			   });
	        }
	    })
	  },false);
	inputObj.click();
}
//处理医保中心异常(冲正)
function btnStrikeForInsu()
{
	var selectedRow = $('#centererrdg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择医保异常的记录！','info');
		return;
	}
	
	var rtncode=-1;
	var clrOptins=selectedRow.clrOptins;
	var Rowid=selectedRow.Rowid;
	var djlsh=selectedRow.djlsh;
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^"+ClrType+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	if((ClrType=="11")||(ClrType=="41")){
		//Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpString,CPPFlag)
		rtncode=InsuOPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}else{
		rtncode=InsuIPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('提示','处理失败: ' + rtncode,'info');
	}else{
		$.messager.alert('提示','处理完毕，如果医保和HIS都没有异常就可以再次对总账了','info');
		var hndInfo="1^"+PUB_CNT.SSN.USERID;
		UpdUnusualHndInfo(Rowid,hndInfo) ;//更新异常处理结果信息 DingSH 20210512
		var dgindex = $('#centererrdg').datagrid('getRowIndex', selectedRow);
		selectedRow.hndFlag="已冲正";
		selectedRow.hndFUser=Guser;
	    $('#centererrdg').datagrid('updateRow',{index: dgindex,row:selectedRow});
	}
}
///更新异常处理信息
function UpdUnusualHndInfo(rowid,hndInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.Unusual",
		MethodName: "UpdUnusualHndInfo",
		type: "GET",
		rowid: rowid,
		hndInfo: hndInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('提示','处理完毕','info');}
       else{{$.messager.alert('提示','更新异常'+rtn,'info');}}
	});	
	
	}
function btnStrikeForHis()
{
	var selectedRow = $('#centererrdg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择医保异常的记录！','info');
		return;
	}
	var rtncode=-1;
	var clrOptins=selectedRow.clrOptins;
	var Rowid=selectedRow.Rowid;
	var blHisDivDr="";
	var BillNo="";
	//selectedRow.psnno,selectedRow.zylsh,selectedRow.InsuTotAmt,selectedRow.djlsh
	blHisDivDr=tkMakeServerCall("INSU.MI.DAO.Unusual","GetDivByStr",selectedRow.psnno,selectedRow.djlsh,selectedRow.zylsh,selectedRow.InsuTotAmt);
	if(blHisDivDr==""){$.messager.alert('提示','未定位到HIS医保结算表异常的记录！','info');return ;}
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	if((ClrType=="11")||(ClrType=="41")){
		
		rtncode=InsuOPDivideCancleForHis(0,PUB_CNT.SSN.USERID,blHisDivDr,hiType,"",ExpString,"")
	}else{
		var divstr=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivById",blHisDivDr);
		if(divstr.length>10){
			BillNo=divstr.split("^")[3]
			if(BillNo=="") {$.messager.alert('提示','未找到账单号！','info');return;}
		}
		
		rtncode=InsuIPDivideCancleForHis(0,PUB_CNT.SSN.USERID,BillNo,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('提示','处理失败: ' + rtncode); 
	}else{
		$.messager.alert('提示','处理完毕，如果医保和HIS都没有异常就可以再次对总账了','info');
		var hndInfo="1^"+Guser;
		UpdUnusualHndInfo(Rowid,hndInfo) ;//更新异常处理结果信息 DingSH 20210512
	}
}
//弹窗
function ShwBlRsDialog(field, value, rowIndex) {
	if (field == "stmtRsltDscr")
	{
	 $('#blResult').val(value);
	 $('#ShwBlRsdl').window('open');
	}
}

//导出中心异常数据
function btnCenterErrEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	UnusualEpot(DivSumDr,1)
}

//导出HIS异常数据
function btnHisErrEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	UnusualEpot(DivSumDr,0)
}

//异常数据导出
function UnusualEpot(DivSumDr,blFlag)
{
	
	var ExcelName="hiserrr"+getExcelFileName()
	if (blFlag==1){
		ExcelName="centererr"+getExcelFileName();
		}
	$.messager.progress({
			   title: "提示",
			   msg: '正在导出异常数据',
			   text: '导出中....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.Unusual","DivUnusualQuery",DivSumDr,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,blFlag,"1");
	location.href = rtn ; 	
	setTimeout('$.messager.progress("close");', 3 * 1000);
  /* try
   {
   var rtn = $cm({
   dataType:'text',
   ResultSetType:"Excel",
   ExcelName:"err", //默认DHCCExcel
   ClassName:"INSU.MI.DAO.Unusual",
   QueryName:"DivUnusualQuery",
   blDivSumDr:DivSumDr,
   HospDr:HospDr,
   UserId:Guser,
   blFlag:blFlag
	},false);
	
	alert("rtn="+rtn)
	location.href = rtn;
   $.messager.progress({
			   title: "提示",
			   msg: '正在导出异常数据',
			   text: '导出中....'
		   });
   setTimeout('$.messager.progress("close");', 3 * 1000);	
	   
	  
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   };*/

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

//关闭弹窗时调用后台kill global WangXQ 20220629
function kImportDataGlobal(Pid){
	
	tkMakeServerCall("INSU.MI.DAO.HisDivInfo","kImportDataGlobal",Pid);
	}

// +20230301 初始化医疗机构
function initInsuHospCmb(){
 $HUI.combobox('#InsuHospCode',{   
	    url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('InsuHospCode'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		},
		value: ''
	}); 
}

//初始化对照类型 +20230301
function initBlModType(){ 
	$HUI.combobox('#blModType', {
		panelHeight: 'auto',
		data: [{
				value: '0',
				text: '月对账',
				'selected':true
			}, {
				value: '1',
				text: '日对账'
			}
		],
		valueField: 'value',
		textField: 'text'
	  });
}
//初始化对账状态 +20230301
function initBlStatus(){
	  $HUI.combobox('#blStatus', {
		panelHeight: 'auto',
		data: [{
				value: '0',
				text: '未对账'
				//'selected':true
			}, {
				value: '1',
				text: '对账成功'
			}, {
				value: '2',
				text: '对账失败'
			}, {
				value: '3',
				text: 'HIS对账作废'
			}
		],
		valueField: 'value',
		textField: 'text'
	  });
}
function checkLock(){
	try{
		var rtn = tkMakeServerCall("INSU.MI.DAO.DivSum","CheckDivSumLock",session['LOGON.USERCODE'],session['LOGON.USERNAME'],session['LOGON.HOSPID']);
		if(rtn.split("^")[0] != "1"){
			$.messager.popover({
				msg: '抱歉界面正在被操作，您只能查询。操作人：' + rtn,
				type: 'info',
				timeout: 4000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
			$('.hisui-linkbutton:not(#btnDivSumQuery)').linkbutton('disable');
			$('#btnStrikeForHis,#btnStrikeForInsu').hide();
			LockFlag = "Y";
		}
	}catch(e){
		return true;
	}
}	
//清空表格内容
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
/*
 * 界面离开清除临时锁
 * 2023-04-14 DingSH  
 * Juquery 1.8 已经弃用
 */
 $(window).unload(function(){
 	ReleaseDivSumLock();
});

/*
 * 界面离开清除临时锁
 * 新的chrome下，用visibilitychange替换unload事件
 *  2023-04-14 DingSH 
 */
window.addEventListener("beforeunload",function(e){
      e.preventDefault();
 	  e.returnValue = '';
	  ReleaseDivSumLock();
});
/*
 *清除临时锁
 */
function ReleaseDivSumLock(){
	
	try{
		$.cm({
				ClassName: "INSU.MI.DAO.DivSum",
				MethodName: "ReleaseDivSumLock",
				type: "BEACON",  //参数按规定必须有
				OptUserCode: session['LOGON.USERCODE'],
				OptHosp: session['LOGON.HOSPID']
			});
		}catch(ex){}
	}