/**
* FillName: dhcinsu/divmonstmtmx.js
* Description: 医保对明细账
* Creator DingSH
* Date: 2021-07-12
*/
// 定义常量
var PUB_CNT = {
	HITYPE:'',                               //医保类型
	REFDSETLFLAG:'1',                        //退费结算标志（为0时，总账对账数据不包含退费数据；为1、空值、null、缺省时，总账对账数据包含退费数据）
	DLALLFLAG:'1',                           //是否可以传空文件下载全部明细1/0
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
	
	//初始化对平标识
	initErrFlagCmb();
	
	//初始退费结算标识
	initRefdSetlFlagCmb();
	
	//HIS结算明细
	initHisDivDetDgDg();
	
	//医保结算明细
	initCenterDivDetDg();

}
//设置页面元素事件
function setElementEvent()
{
	
	 //同步HIS结算数据
    $("#btnSynHisDiv").click(function () {
        SynHisDiv();
    });
 
      /*查询*/
	 $("#btnDivQuery").click(function () {
        DivHisQuery_click();
        DivCenterQuery_click();
    });
   

   /*对账*/
    $("#btnDivStmt").click(function () {
        DivStmt_Click();
    });
    
    /*医保中心细下载*/
    $("#btnCenterDivDL").click(function () {
        CenterDivDL_click();
    });
	
    /*导入医保明细--需要按照规定格式提供数据*/
    $("#btnImportCenterDiv").click(function () {
        btnImportCenterDiv();
    });
	/*处理医保中心异常*/
	$('#btnStrikeForInsu').click(function(){
		var oldOk = $.messager.defaults.ok;
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
	$('#btnStrikeForHis').click(function(){btnStrikeForHis()});
	/*导入第三方数据ForHIS,适合第三方和医保中心交互这种*/
	$('#btnImportThirdDet').click(function(){btnImportThirdDet();});
	/*导出中心异常*/
	$('#btnCenterDivEpot').click(function(){btnCenterDivEpot();});
	/*导出HIS异常*/
	$('#btnHisDivEpot').click(function(){btnHisDivEpot();});
  
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
		onLoadSuccess:function(){
			$('#hiType').combobox('select','00A');
			},
		onSelect:function(rec){
			PUB_CNT.HITYPE = rec.cCode;
			initSetlOptinsCmb();
			initInsutypeCmb();
			initClrTypeCmb();
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
		value: '11'
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
//初始化异常标识
function initErrFlagCmb()
{
	$HUI.combobox('#errFlag',{
		//url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		data:[
		       {cCode:"",cDesc:"全部"},
		       {cCode:"1",cDesc:"是"},
		       {cCode:"0",cDesc:"否"}
		      ],
		 value:''
	});
}
//初始化退费结算标识
function initRefdSetlFlagCmb()
{
	$HUI.combobox('#refdSetlFlag',{
		//url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		data:[
		       {cCode:"",cDesc:"全部"},
		       {cCode:"1",cDesc:"是"},
		       {cCode:"0",cDesc:"否"}
		      ],
		 value:''
		
	});
}
//初始化HIS结算明细dg
function initHisDivDetDgDg()
{
	 $HUI.datagrid('#HisDivDetDg',{
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:20,
		pageList:[10, 20, 30],
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
		    {field:'patNo',title:'登记号',width:120},
		    {field:'psnName',title:'姓名',width:100},
		    {field:'stRslt',title:'对平',width:60,align:'center',styler: function(value,row,index){
				        var rtnStyle="background-color:#EE4F38;color:white";
					    if (row.DivCenterDr>0)
					    {
	    		            rtnStyle= 'background-color:#51B80C;color:white';
	                     }	
					return rtnStyle;
				},
				formatter: function(value,row,index){
				if (row.DivCenterDr>0){
					return "是";
				} else {
					return "否";
				}
			   }
			},
		    {field:'djlsh',title:'结算事件Id',width:150},
		    {field:'zylsh',title:'就诊事件Id',width:150}
		]],
		columns:[[
		    
		    {field:'msgid',title:'发送机交易流水号',width:260},
		    {field:'psnno',title:'个人编号',width:150},
		    {field:'PsnCertType',title:'证件类型',width:150},
		    {field:'Certno',title:'证件号码',width:150},
			{field:'RefdSetlFlag',title:'退费结算标识',width:120},
			{field:'Xzlb',title:'险种类型',width:150,hidden:true},
			{field:'XzlbDesc',title:'险种类型',width:150},
			{field:'ClrType',title:'清算类别',width:80,hidden:true},
			{field:'ClrTypeDesc',title:'清算类别',width:80},
			{field:'HisTotAmt',title:'总金额',width:100,align:'right'},
			{field:'HisJjzfe',title:'基金支付总额',width:100,align:'right'},
			{field:'HisZhzfe',title:'账户支付总额',width:100,align:'right'},
			{field:'HisGrzfe',title:'个人自付总额',width:100,align:'right'},
			{field:'blFlag',title:'对账标志',width:100,hidden:true},
			{field:'ClrOptins',title:'清算经办机构',width:150},
			{field:'SetlOptins',title:'结算经办机构',width:120},
			{field:'DivDate',title:'结算日期',width:120},
			{field:'DivTime',title:'结算事件',width:120},
			{field:'AdmDate',title:'就诊日期',width:120},
			{field:'DisDate',title:'出院日期',width:120},
			{field:'LocName',title:'就诊科室',width:120},
			{field:'AdmType',title:'医疗类别',width:120},
			{field:'PatType',title:'人员类型',width:120},
			{field:'DivType',title:'结算类型',width:120},
			{field:'InsuOptins',title:'参保统筹区划',width:120},
			{field:'BusiType',title:'业务类',width:120,hidden:true},
			{field:'HiType',title:'医保类型',width:100},
			{field:'Rowid',title:'Rowid',width:80,hidden:true},
			{field:'DivideDr',title:'DivideDr',width:80,hidden:true},
			{field:'AdmDr',title:'AdmDr',width:80,hidden:true},
			{field:'DivCenterDr',title:'DivCenterDr',width:80,hidden:true},
			{field:'DivSumDr',title:'DivSumDr',width:80,hidden:true}
		]],
        onSelect:function(rowIndex, rowData) {
	        //SetBtnIsDisabled(rowData.blFlagDesc);
            //DivUnusualQuery(rowData.Rowid);
            //DivDetQuery();
        },
      
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onDblClickRow:function(rowIndex,rowData){
				
		}
	});
}
//初始化医保结算明细dg
function initCenterDivDetDg()
{
	 $HUI.datagrid('#CenterDivDetDg',{
		rownumbers:true,
		split:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:20,
		pageList:[10, 20, 30],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
			{field:'stRslt',title:'对平',width:60,align:'center',styler: function(value,row,index){
					        var rtnStyle="background-color:#EE4F38;color:white";
						    if (row.blHisDivDr>0)
						    {
		    		            rtnStyle= 'background-color:#51B80C;color:white';
		                     }	
						return rtnStyle;
					},
					formatter: function(value,row,index){
						
				   if (row.blFlag == '3'){
						   return "冲正";
						}
					if (row.blHisDivDr>0){
						return "是";
					} else {
						return "否";
					}
					
					
				   }
				},
			    {field:'djlsh',title:'结算事件Id',width:150},
			    {field:'zylsh',title:'就诊事件Id',width:150}
		]],
		columns:[[
		    //{field:'patNo',title:'登记号',width:150},
		    //{field:'psnName',title:'姓名',width:100},
		    
		    {field:'msgid',title:'发送机交易流水号',width:260},
		    {field:'psnno',title:'个人编号',width:150},
		    {field:'PsnCertType',title:'证件类型',width:150},
		    {field:'Certno',title:'证件号码',width:150},
			{field:'RefdSetlFlag',title:'退费结算标识',width:120},
			{field:'Xzlb',title:'险种类型',width:150,hidden:true},
			{field:'XzlbDesc',title:'险种类型',width:150},
			{field:'ClrType',title:'清算类别',width:80,hidden:true},
			{field:'ClrTypeDesc',title:'清算类别',width:80},
			{field:'InsuTotAmt',title:'总金额',width:100,align:'right'},
			{field:'InsuJjzfe',title:'基金支付总额',width:100,align:'right'},
			{field:'InsuZhzfe',title:'账户支付总额',width:100,align:'right'},
			{field:'InsuGrzfe',title:'个人自付总额',width:100,align:'right'},
			{field:'blFlag',title:'对账标志',width:100,hidden:true},
			{field:'ClrOptins',title:'清算经办机构',width:150},
			{field:'AdmType',title:'医疗类别',width:120},
			{field:'PatType',title:'人员类型',width:120},
			{field:'DivType',title:'结算类型',width:120},
			{field:'BusiType',title:'业务类',width:120,hidden:true},
			{field:'HiType',title:'医保类型',width:100},
			{field:'Rowid',title:'Rowid',width:80,hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',width:80,hidden:true},
			{field:'blDivSumDr',title:'blDivSumDr',width:80,hidden:true}
		]],
        onSelect:function(rowIndex, rowData) {
	        SetBtnIsDisabled(rowData.blFlagDesc);
            DivUnusualQuery(rowData.Rowid);
            DivDetQuery();
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
                disableById("btnDivSumCreateDel");    /*作废对账数据*/
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
		//toolbar:'#dgTB',
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



//对账 
function DivStmt_Click()
{
	var ClrType=getValueById('clrType');
	var StDate=getValueById('stdate');
	var EndDate=getValueById('endate');
	
	 if(ClrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	 }
 	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	 }
	 $.messager.progress({
		title: "提示",
		text: '正在下载中心明细请稍后....'
	 });
	 try{
	    //同步退费结算标识
		SynRefdStelFlag();
		//同步对账明细数据
		SynDivDetStmt();
		DivHisQuery_click();
        DivCenterQuery_click();
        
	 }
	 catch(ex){}
	 finally
	 {
			 
		$.messager.progress("close"); 
	 }
}

///同步对账明细数据
function SynDivDetStmt()
{
	var Xzlb=getValueById('insutype');
	var ClrType=getValueById('clrType');
	var StDate=getValueById('stdate');
	var EdDate=getValueById('endate');
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynDivDetStmt",
		StDate: StDate,
		EdDate: EdDate,
		HiType: PUB_CNT.HITYPE,
		ClrType:ClrType,
		Xzlb:Xzlb,
		BusiType:'1',
		RefdSetlFlag:"",
		SetlOptions:"",
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"同步对账异常："+rtn);
		}else{
			   $.messager.alert('提示','同步对账完成');
			}
	  
	});
}

///同步退费结算标识
function SynRefdStelFlag()
{
	
	var EdDate=getValueById('endate');
	var trtMonth=EdDate.split("-")[0]+""+EdDate.split("-")[1];
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynRefdStelFlag",
		trtMonth: trtMonth,
		HospDr:PUB_CNT.SSN.HOSPID,
		HiType: PUB_CNT.HITYPE
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('提示',"同步退费结算标识异常："+rtn);
		}else{
			   $.messager.alert('提示','同步退费结算标识完成');
			}
	  $.messager.progress("close");
	});
}

//查询HIS结算明细
function DivHisQuery_click()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var Options=$('#setlOptins').combobox('getValue');
	var ErrFlag=getValueById('errFlag');
	var refdSetlFlag=getValueById('refdSetlFlag');
	/*if(ClrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	}*/
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#HisDivDetDg',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.HisDivInfo'+"&QueryName="+'HisDivQuery'+"&StDate="+StDate+"&EdDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+refdSetlFlag+"&SetlOptions="+Options+"&ErrFlag="+ErrFlag    

	})
}


//查询医保结算明细
function DivCenterQuery_click()
{
	
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ErrFlag=getValueById('errFlag')
	//var Options=$('#setlOptins').combobox('getValue');
	var refdSetlFlag=getValueById('refdSetlFlag');
	/*if(ClrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	}*/
	
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#CenterDivDetDg',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.CenterDivInfo'+"&QueryName="+'CenterDivQuery'+"&StDate="+StDate+"&EdDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+refdSetlFlag+"&ErrFlag="+ErrFlag   

	})
}

//医保中心明细下载
function CenterDivDL_click(){
	
	/*var xzlb=getValueById('insutype');
	if(xzlb==""){
		$.messager.alert('注意','险种类别不能为空！');
		return;
	}*/
	var xzlb="";
	var clrType=getValueById('clrType');
	if(clrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	}
	var stdate=getValueById('stdate');
	if(stdate==""){
		$.messager.alert('注意','开始日期不能为空！');
		return;
	}
	var endate=getValueById('endate');
	if(endate==""){
		$.messager.alert('注意','结束日期不能为空！');
		return;
	}
	var setlOptins=getValueById('setlOptins');

	if(setlOptins==""){
		   //$.messager.alert('注意','结算经办机构不能为空');
		   //return
		    var oldOk = $.messager.defaults.ok;
		    var oldCancel = $.messager.defaults.cancel;
			$.messager.defaults.ok = "是";
			$.messager.defaults.cancel = "否";
			$.messager.confirm("重要提示", "结算经办机构为空,是否全部下载医保中心明细?", function (r) {
		    if (r) {
             DLDivCenter();
		    }
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.cancel = oldCancel;
	
	     });
        
   }else
   {
	   DLDivCenter();
 }
  				
   
 //SynDivDetStmt();
}


function DLDivCenter()
{
	var xzlb="";
	var clrType=getValueById('clrType');
	var stdate=getValueById('stdate');
	var endate=getValueById('endate');
	var setlOptins=getValueById('setlOptins');
	$.messager.progress({
	            title: "提示",
	            text: '正在下载中心明细请稍后....'
             });
		var ExpString="^^^"+PUB_CNT.DLALLFLAG+"^^"+clrType+"^"+xzlb+"^"+stdate+"^"+endate+"^"+setlOptins+"^"+PUB_CNT.REFDSETLFLAG+"^"+PUB_CNT.HITYPE+"^"+PUB_CNT.SSN.HOSPID
		var rtn=InsuLiquidationMx(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		$.messager.progress("close");
	    if(rtn<0){
				$.messager.alert('错误','对明细账失败！');
				return;
			  }else{
				$.messager.alert('提示','对账明细完成');
			  }
}
//同步HIS医保结算数据
function SynHisDiv() 
{
	var ClrType=$('#clrType').combobox('getValue');
	if(ClrType == ""){
		$.messager.alert('提示','清算类别不能为空');
		return;
	}
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "提示",
		text: '正在同步HIS医保结算数据请稍后....'
	});

	//同步数据
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
			$.messager.alert('提示','同步HIS医保结算数据发生错误！rtn='+rtn);
			return;	
		}else{
			 $.messager.alert('提示','同步HIS医保结算数据成功:'+rtn,'info',function(){DivSumCreate_Click();});
			}
		DivHisQuery_click();
        DivCenterQuery_click();
	});
}
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
			
		},
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

function btnImportCenterDiv(){

	var DivSumDr = "",TrtMonth="";
	var trtMonth="";
	var BusiType="1";
	if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('提示','结束日期不能为空');return;}
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
		            $.messager.alert('提示','导入完毕！');
		        }else{
					$.messager.alert('提示','导入失败: ' + res);   
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

	
	/*if(!selectedRow){
		$.messager.alert('提示','请选择对总账的记录！');
		return;
	}
	if(selectedRow.blFlag!="待对账"){
		$.messager.alert('提示','非待对账状态不允许第三方明细！');
		return;
	}*/
	var DivSumDr = "",trtMonth="";
	var trtMonth=getValueById("endate");
	var BusiType="1";
    if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('提示','结束日期不能为空');return;}
		var trtMonth=(encdate.slice(0,7)).replace("-","");
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
	    if((file==null)||(file==undefined)) return;
	    $.messager.progress({
		title: "提示",
		text: '正在导入第三方医保数据....'
	   });
	    var form = new FormData();
	    form.append("FileStream", file); //第一个参数是后台读取的请求key值
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+'ImportHisDivInfoFromCSV'+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+trtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
	            if((res=="0")||(res=="\r\n0")){
		            $.messager.alert('提示','导入完毕！');
		        }else{
					$.messager.alert('提示','导入失败: ' + res);   
				}
				$.messager.progress("close");
				DivHisQuery_click();
				
	        }
	    })
	  },false);
	inputObj.click();
}
//处理医保中心异常(冲正)
function btnStrikeForInsu()
{
	var selectedRow = $('#CenterDivDetDg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择医保异常的记录！');
		return;
	}
	if(selectedRow.blHisDivDr>0){
		$.messager.alert('提示','请选择对平状态为:否的记录');
		return;
	}
	var rtncode=-1;
	var clrOptins=selectedRow.ClrOptins;
	var Rowid=selectedRow.Rowid;
	var djlsh=selectedRow.djlsh;
	//var hiType=$('#hiType').combobox('getValue');
	//var ClrType=$('#clrType').combobox('getValue');
	var hiType=selectedRow.HiType;
	if(hiType==""){hiType=$('#hiType').combobox('getValue');}
	var ClrType=selectedRow.ClrType;
	if(ClrType==""){ClrType=$('#clrType').combobox('getValue');}
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^"+ClrType+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	if((ClrType=="11")||(ClrType=="41")){
		//Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpString,CPPFlag)
		rtncode=InsuOPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}else{
		rtncode=InsuIPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('提示','处理失败: ' + rtncode);
	}else{
		$.messager.alert('提示','处理完毕，如果医保和HIS都没有异常就可以再次对总账了');
		var blInfo="3^"+PUB_CNT.SSN.USERID;
		UpdCenterDivBlInfo(Rowid,blInfo) ;//更新异常处理结果信息 DingSH 20210512
		DivCenterQuery_click();
	}
}
///更新医保中心结算流水表对账信息
function UpdCenterDivBlInfo(rowid,blInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.CenterDivInfo",
		MethodName: "UpdCenterDivBlInfo",
		type: "GET",
		rowid: rowid,
		blInfo: blInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('提示','处理完毕');}
       else{{$.messager.alert('提示','更新异常'+rtn);}}
	});	
	
}


///更新HIS医保结算流水表对账信息
function UpdHisDivBlInfo(rowid,blInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.HisDivInfo",
		MethodName: "UpdHisDivBlInfo",
		type: "GET",
		rowid: rowid,
		blInfo: blInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('提示','处理完毕');}
       else{{$.messager.alert('提示','更新异常'+rtn);}}
	});	
	
}

function btnStrikeForHis()
{
	var selectedRow = $('#HisDivDetDg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('提示','请选择医保异常的记录！');
		return;
	}
	if(selectedRow.DivideDr==""){
		$.messager.alert('提示','请核实是否是导入HIS数据！');
		 return;
	 }
	if(selectedRow.DivCenterDr >0){
		$.messager.alert('提示','请选择对平状态为：否的记录');
		 return;
		}	
		
	var rtncode=-1;
	var clrOptins=selectedRow.ClrOptins;
	var Rowid=selectedRow.Rowid;
	var blHisDivDr="";
	var BillNo="";
	//selectedRow.psnno,selectedRow.zylsh,selectedRow.InsuTotAmt,selectedRow.djlsh

	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.HisTotAmt+"^"+selectedRow.msgid+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	if((ClrType=="11")||(ClrType=="41")){
		
		rtncode=InsuOPDivideCancleForHis(0,PUB_CNT.SSN.USERID,selectedRow.DivideDr,hiType,"",ExpString,"")
	}else{
		var divstr=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivById",selectedRow.DivideDr);
		if(divstr.length>10){
			BillNo=divstr.split("^")[3]
			if(BillNo=="") {$.messager.alert('提示','未找到账单号！');return;}
		}
		rtncode=InsuIPDivideCancleForHis(0,PUB_CNT.SSN.USERID,BillNo,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('提示','处理失败: ' + rtncode); 
	}else{
		$.messager.alert('提示','处理完毕，如果医保和HIS都没有异常就可以再次对总账了');
		var blInfo="3^"+PUB_CNT.SSN.USERID;
		UpdHisDivBlInfo(Rowid,blInfo) ;//更新异常处理结果信息 DingSH 20210512
		DivHisQuery_click();
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

//导出医保中心端数据
function btnCenterDivEpot()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ErrFlag=getValueById('errFlag')
	//var Options=$('#setlOptins').combobox('getValue');
	var refdSetlFlag=getValueById('refdSetlFlag');
	if(ClrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	}
	
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	var ExcelName="CenterDiv"+getExcelFileName();
	$.messager.progress({
			   title: "提示",
			   msg: '正在导出医保中心端数据',
			   text: '导出中....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.CenterDivInfo","CenterDivQuery",StDate,EndDate,hiType,ClrType,Xzlx,"1",refdSetlFlag,ErrFlag,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,"","1");
	location.href = rtn ; 	
	setTimeout('$.messager.progress("close");', 3 * 1000);
	
}

//导出医院端医保数据
function btnHisDivEpot()
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var Options=$('#setlOptins').combobox('getValue');
	var ErrFlag=getValueById('errFlag');
	var refdSetlFlag=getValueById('refdSetlFlag');
	if(ClrType==""){
		$.messager.alert('注意','清算类别不能为空！');
		return;
	}
	if(StDate==""||EndDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(hiType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	var ExcelName="HisDiv"+getExcelFileName()
	$.messager.progress({
			   title: "提示",
			   msg: '正在导出医院端数据',
			   text: '导出中....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.HisDivInfo","HisDivQuery",StDate,EndDate,hiType,ClrType,Xzlx,"1",refdSetlFlag,Options,ErrFlag,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,"","1");
	location.href = rtn ; 	
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
