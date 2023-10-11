/**
 * FileName: dhcinsu.dataulmain.js
 * Anchor: wxq
 * Date: 2022-06-10
 * Description: 医保数据上传管理
 * 
 */
 
var GV={
	 mainDtlList:null,
	 PortListDic:null,
	 m_PARID:"",
	 m_AdmDr:"",
	 m_DivDr:"",
	 m_OptType:"",
	 m_HospDr:"",
	 m_USERID:session['LOGON.USERID'],
	 DPLRowid:"",
	 DPLInfno:"",
	 m_AdmType:"",
	 m_PrtDr:"",
	 m_BillDr:"",
	 m_ddv:null,
	 HOSPID:session['LOGON.HOSPID']
	 }
$(document).ready(function () {	


   var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			ClearDatagrid();
			initQueryMenu();
			loadDataDtlList();
		},
		onLoadSuccess: function(data){
			ClearDatagrid();
			initQueryMenu();
			loadDataDtlList();
		}
	});
	
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initDataDtlList();
	//initHOSPID();
	initInsuType();
	InitPortListDicDg();
	InitPortListULDg();
	initPortListSubYDg();
	initPortListSubNDg();
	initPortListSubFDg();
	var opt={width:"220"}
	GenUserHospComp(opt);
});





function initQueryMenu() {
	
	
	GV.HOSPID=$HUI.combogrid("#_HospUserList").getValue() ;
	//$('#_HospUserList').combogrid('panelWidth', '220');
	initInsuType();
	
	$('#SDate, #EDate').datebox();
	
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			
			loadDataDtlList();
		}
	});

	//登记号回车查询事件
	$('#PatNo').keydown(function (e) {
		
		patientNoKeyDown(e);
	});
	
	//病案号回车查询事件
	$('#MedNo').keydown(function (e) {
	
		MedicareNoKeyDown(e);
	});
	
	///上传标志
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: '未上传',
				'selected':true
			}, {
				value: '2',
				text: '已上传'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {	
		   if(data.value=="2"){
			  $('#DateFlag').combobox('select',5);
			}				
		}
	});
	
	///日期标志
	$HUI.combobox('#DateFlag', {
		panelHeight: 'auto',
		data: [/*{
				value: '1',
				text: '入院日期',
			}, {
				value: '2',
				text: '出院日期'
			},*/{
				value: '3',
				text: '结算日期',
				'selected':true
			}, {
				value: '4',
				text: '编目日期',				
			}, {
				value: '5',
				text: '上传日期',				
			}
		],
		valueField: 'value',
		textField: 'text'
	});	
	
	///业务类型
	$HUI.combobox('#OptType', {
		panelHeight: 'auto',
		data: [{
				value: 'OP',
				text: '门诊',				
			}, {
				value: 'IP',
				text: '住院',
				'selected':true
			}
		],
		valueField: 'value',
		textField: 'text',		
	});

	$('#SDate, #EDate').datebox('setValue', getDefStDate(0));
	$("#btn-up").click(BUpClickHandle);
	$("#btn-del").click(BDelClickHandle);
	$("#info").select();
	$('#InfoWin').dialog({
		buttons:[{
			text:'关闭',
			handler:function(){
				$('#InfoWin').dialog('close');
			}
		},
		{
			text:'复制',
			handler: function(){
			    //copyText($("#copyInfo").text());
				//upt DingSH 20220708
				var pre = document.getElementById("copyInfo")
				var text = pre.innerText;
				var input =$("<textarea></textarea>");
		    	input.text(text); // 修改文本框的内容
		    	input.appendTo(pre);
		    	input.select(); // 选中文本
		    	document.execCommand("copy"); // 执行浏览器复制命令
		    	input.remove();
		    	//$.messager.alert("提示", "复制成功!", 'info');
				$.messager.popover({
				msg: '复制成功：' ,
				type: 'info',
				timeout: 1000, 		//0不自动关闭。3000s
				showType: 'slide'  
			});
			}
		}]
		})
		
		
}


function patientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (PatNo) {
			$(e.target).val(PatNo);
			loadDataDtlList();
		});
	}
}

//病案号回车事件
function MedicareNoKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		var MedNo = jQuery("#MedNo").val();
		loadDataDtlList();
	}
}

function setUpbtnAbled(PrtActStus,UpFlag)
{
  var PrtActStusN=PrtActStus||"";	
  var UpFlagN= UpFlag || "";	   
  //todo ...Flag 规则 
  var Flag=PrtActStusN;				        					        
  switch (Flag)
	    { 
	      case "Y" :
              enableById("btn-up");    
			  enableById("btn-del");    
                break;
           case "N" :
                 disableById("btn-up");    
			     disableById("btn-del"); 
                break;
           default :
                 enableById("btn-up");    
			     enableById("btn-del"); 
                 break;
         }					        			        
	return 	;			        
					       				        
}

function initDataDtlList() {
 GV.mainDtlList=$HUI.datagrid('#mainDtlList', {
		fit:true,
		border: false,
		striped: true,
		//singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar:[],
		columns: [[
		{
		
				title: 'ck',
				field: 'ck',
				checkbox: true
				},
		         {
					title: '上传标志',
					field: 'TOptFlag',
					align: 'left',
					width: 80,
					formatter: function (value, row, index) {
						//btnstr="<a type='button'  onclick=\"EprListDetail(\'" + row.Did + "\')\" style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						btnstr="<a type='button'   style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						return btnstr						
					}
				}, {
					title: '姓名',
					field: 'TPatName',
					align: 'left',
					width: 80
				},{
					title: '登记号',
					field: 'TPatRegNo',
					align: 'left',
					width: 100
				},  {
					title: '病案号',
					field: 'TMedcasNo',
					align: 'left',
					width: 100
				}, {
					title: '住院科室',
					field: 'TDepDesc',
					align: 'left',
					width: 120
				}, {
					title: '入院日期',
					field: 'TAdmDate',
					align: 'left',
					width: 100
				}, {
					title: '出院日期',
					field: 'TOutDate',
					align: 'left',
					width: 100
				}, {
					title: '结算日期',
					field: 'TDisDate',
					align: 'left',
					width: 100
				},{
					title: '发票状态',
					field: 'TPrtActStus',
					align: 'left',
					width: 80,
					styler: function(value,row,index){
				        var rtnStyle="";
					    switch (value)
					    { 
					      case "N" :
	    		                rtnStyle= 'color:red';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }		
					return rtnStyle
				},
				formatter: function(value,row,index){
				if (value == "Y"){
					return "有效";
				} else {
					return "无效";
				}
			   }
				
				}, {
					title: '医保卡号',
					field: 'TInsuNo',
					align: 'left',
					width: 120
				}, {
					title: '医保登记id',
					field: 'TInsuZylsh',
					align: 'left',
					width: 160,
					hidden:true
				}, {
					title: '医保结算id',
					field: 'TInsuDjlsh',
					align: 'left',
					width: 160,
					hidden:true
				}
				, {
					title: '上传人员',
					field: 'TOpter',
					align: 'left',
					width: 100
				}, {
					title: '上传日期',
					field: 'TOptDate',
					align: 'left',
					width: 150
				}, {
					title: '医保类型',
					field: 'TInsuType',
					align: 'left',
					width: 80
				}, {
					title: 'Rowid',
					field: 'Did',
					align: 'left',
					width: 60
				}, {
					title: 'AdmDr',
					field: 'AdmDr',
					align: 'left',
					width: 60
				}, {
					title: 'DivDr',
					field: 'DivDr',
					align: 'left',
					width: 60
				}, {
					title: '就诊类型',
					field: 'TAdmType',
					align: 'left',
					width: 80
				}, {
					title: '医院',
					field: 'THospID',
					align: 'left',
					width: 60
				}, {
					title: '发票Dr',
					field: 'TPrtDr',
					align: 'left',
					width: 80
				}
				
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
				//$("a[name='view']").linkbutton({});
			},
			
		  onSelect:function(index,row){
			        setUpbtnAbled(row.TPrtActStus);
					GV.m_PARID=row.Did;
			        GV.m_AdmDr=row.AdmDr;
			        GV.m_DivDr=row.DivDr;
			        GV.m_OptType=$('#OptType').combobox('getValue');
			        GV.m_PrtDr=row.TPrtDr;
		            //GV.m_HospDr=$('#HOSPID').combobox('getValue');
		            GV.m_HospDr=row.THospID;
		            GV.m_InsuType=row.TInsuType;
		            QryPortListDic(row)
		            
		            
					}
					
			
			
		
	});

}
/*
 * 清空指定元素的datagird数据
 * ClearDatagrid('PortListDic','PortListUL') 
 * ClearDatagrid() 入参为空,情况默函数指定的全部元素grid数据
*/
function ClearDatagrid(){
	   var elms=arguments
	   if (arguments.length==0){
	      elms=['PortListDic','PortListUL','PortListSubY','PortListSubN','PortListSubF']
	   }
	   elms.forEach(function(elm) {
           var dg =$HUI.datagrid('#'+elm)
	      if( typeof dg!="undefined" ){
	          dg.loadData({total:0,rows:[]})
	        }
         });
	}
function loadDataDtlList() {
	setUpbtnAbled("")
	ClearDatagrid();  ///LuJH 2022 10-19
	var stDate = $('#SDate').datebox('getValue');
	var endDate = $('#EDate').datebox('getValue');
	var queryParams = {
		ClassName: 'web.DHCINSUDataUL',
		QueryName: 'QueryPat',
		MedNo: $('#MedNo').val(),
		PatNo: $('#PatNo').val(),		
		SDate: stDate,
		EDate: endDate,		
		DateFlag: $('#DateFlag').combobox('getValue') || '',
		UpFlag: $('#UpFlag').combobox('getValue') || '',		
		InsuType: $('#InsuType').combobox('getValue') || '',
		OptType:$('#OptType').combobox('getValue') || '',
		HOSPID: GV.HOSPID || '',
	};	
	loadDataGridStore('mainDtlList', queryParams);

}

function initHOSPID(){
	$('#HOSPID').combogrid({  
	    panelWidth:350,   
	    panelHeight:220,  
	    idField:'Rowid',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryHospInfo';
	     },
	    columns:[[   
	        {field:'Rowid',title:'数据ID',width:60},  
	        {field:'Desc',title:'描述',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(){
		   initInsuType()
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#HOSPID').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	}); 	
}
function initInsuType(){
	$('#InsuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:220,
	    idField:'Code',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.DHCINSUDataUL';
	      	param.QueryName = 'QueryDicInfo';
	      	param.DicType="DLLType"
	      	param.HospDr =GV.HOSPID ;
	     },
	    columns:[[   
	        {field:'Code',title:'数据ID',width:40},  
	        {field:'Desc',title:'描述',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function()
	    {	
	      //$('#mainDtlList').datagrid({data:[]});	 
	      loadDataDtlList(); //LuJH 2022.07.06
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				//$('#InsuType').combogrid('grid').datagrid('selectRow',0);
				$('#InsuType').combogrid('grid').datagrid('selectRecord','00A'); //可修改
		    }
		}
	}); 	
}


//查询上传字典
function QryPortListDic(row){

    var queryParams = {
	    ClassName : 'web.DHCINSUDataUL',
	    QueryName : 'QueryPortListDic',
	    PARID:row.Did,
	   OptType:$('#OptType').combobox('getValue'),
	   HospDr:row.THospID,
	   InsuType:row.TInsuType
	    
	}	
    loadDataGridStore('PortListDic',queryParams)

}


//初始化上传字典
function InitPortListDicDg() {
	GV.PortListDic=	$('#PortListDic').datagrid({
		fit:true,
		border:false,
		striped:true,
		//singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 10,
		pagination: true,
		toolbar:[],
		columns: [[
			{
	
				title: 'ck1',
				field: 'ck1',
				checkbox: true,
			},
				{
				title: '交易编号',
				field: 'TradeNo',
				align: 'left',
				width: 80,
			}, {
				title: '交易名称',
				field: 'TradeDesc',
				align: 'left',
				width: 150
			},{
				title: '上传标志',
				field: 'UpFlag',
				align: 'left',
				width: 80,
				styler:UpFlagStyle
			}
			
			, {
				title: '上传人',
				field: 'OptUser',

			}, {
				title: '上传日期',
				field: 'OptDate',

			}
			, {
				title: '上传时间',
				field: 'OptTime',

			}
			,{
				title: 'Rowid',
				field: 'DPLid',
				hidden:true
			}
			,{
				title: 'Rowid',
				field: 'DParid',
				hidden:true
			}
		]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
				//$("a[name='view']").linkbutton({});
			},
			onSelect:function(index,row){
				QryPortListUL(row);
				GV.DPLInfno=row.TradeNo; //DingSH 20220623 
				}
	});
}

//查询上传记录
function QryPortListUL(row){

	var queryParams = {
	    ClassName : 'web.DHCINSUDataUL',
	    QueryName : 'QueryPortListUL',
	    PARID:row.DParid,
	    TradeNo:row.TradeNo,   
	}	
    loadDataGridStore('PortListUL',queryParams)
}

//初始化上传记录
function InitPortListULDg() {
	GV.PortListUL=	$('#PortListUL').datagrid({
		fit: true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '上传标志',
				field: 'UpFlag',
				align: 'left',
				width: 120,
				styler:UpFlagStyle
			},{
				field:'InptPara',
				title:'交易入参',
				width:100,
				formatter:setInputInfoFormatter,  //DingSH 20220331
			},{
				field:'OutPara',
				title:'交易出参',
				width:100,
				formatter:setOutputInfoFormatter,
			},{
				title: '上传人',
				field: 'INDPLOpter',
				width:140,
			},{
				title: '上传日期',
				field: 'INDPLOptDate',
				width:140,
			},{
				title: '上传时间',
				field: 'INDPLOptTime',
				width:140,
			},{
				title: 'Rowid',
				field: 'DPLid',
				hidden:true
			},{
				title: 'ParRowid',
				field: 'DParid',
				hidden:true
			},{
				title: 'TradeNo',
				field: 'TradeNo',
				hidden:true
			}
		]],	
	});
}
///初始化明细详细已上传列表
function initPortListSubYDg() {
	$('#PortListSubY').datagrid({
		fit:true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '项目代码',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '项目名称',
				field: 'TradeDesc',
				align: 'left',
				width:150,
			},{
				title: '上传标志',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle,
			},{
				title: '上传人',
				field: 'OptUser',
				width:140,
			},{
				title: '上传日期',
				field: 'OptDate',
				width:140,
			},{
				title: '上传时间',
				field: 'OptTime',
				width:140,
			}
		]],    
	});		    
}

//初始化明细详细未上传列表
function initPortListSubNDg() {
	$('#PortListSubN').datagrid({
		fit:true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '项目代码',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '项目名称',
				field: 'TradeDesc',
				align: 'left',
				width:150,
			},{
				title: '上传标志',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle
			},{
				title: '上传人',
				field: 'OptUser',
				width:140,
			},{
				title: '上传日期',
				field: 'OptDate',
				width:140,
			},{
				title: '上传时间',
				field: 'OptTime',
				width:140,
			}
		]],    
	});		    
}

//初始化明细详细上传失败列表
function initPortListSubFDg() {
	$('#PortListSubF').datagrid({
		fit: true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '项目代码',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '项目名称',
				field: 'TradeDesc',
				align: 'left',
				width: 150
			},{
				title: '上传标志',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle
			},{
				title: '上传人',
				field: 'OptUser',
				width:140,
			},{
				title: '上传日期',
				field: 'OptDate',
				width:140,
			},{
				title: '上传时间',
				field: 'OptTime',
				width:140,
			}
		]],	    
	});			    
}
//上传记录
function BUpClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		var row =myRows[i];
		if (Flag==1){
			var Infno=GV.DPLInfno ; //可以为空,传全部交易
			var InArgType="STR",OutArgType="JSON";
			//医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID^就诊类型^发票Id^账单Id
				      var m_PARID=row.Did || "";
			          var m_AdmDr=row.AdmDr;
			          var m_DivDr=row.DivDr;
			          var m_OptType=$('#OptType').combobox('getValue');
			          var m_PrtDr=row.TPrtDr;
		            //var m_HospDr=$('#HOSPID').combobox('getValue');
		              var m_HospDr=row.THospID;
			          var m_AdmType="";
			          var m_BillDr="";
			          var m_InsuType=row.TInsuType; //自费 或 医保（可以理解费别）
			          var DLLInsuType=m_InsuType; //接口医保类型
			          if (DLLInsuType==""){DLLInsuType="00A";}
			          
			var InArgInfo=DLLInsuType+"^"+Infno+"^"+m_HospDr+"^"+GV.m_USERID+"^0^^1^"+m_AdmDr+"^"+m_DivDr+"^"+m_OptType+"^"+m_PrtDr+"^"+m_BillDr;
			var ExpStr=DLLInsuType+"^^"+m_OptType+"^"+m_PARID+"^"+m_InsuType;
			InsuDataUL(0,GV.m_USERID,InArgInfo,InArgType,OutArgType,ExpStr); //DHCInsuPort.js
			if((GV.PortListDic)&&(Infno)) {
				 GV.PortListDic.datagrid("reload")
				 GV.PortListUL.datagrid("reload")
				}
		}
			
			     
			
		 				
	}	
}
//上传记录作废
function BDelClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1){
			///撤销接口、不允许多条批量撤销
			var DPLRowid=GV.DPLRowid;
			if(GV.DPLRowid==""){
				$.messager.alert("温馨提示","请选择一条撤销的交易", 'info');
				return;
				}
			var ExpStr=$('#InsuType').combobox('getValue')+"^^";
			var InArgInfo=DPLRowid+"^"+GV.m_AdmDr+"^"+GV_m_DivDr,InArgType="STR",OutArgType="JSON";
			InsuAdmDataULCancel(0,GV.m_USERID,InArgInfo,InArgType,OutArgType,ExpStr) ;//DHCInsuPort.js
		}		
	}	
}
function setInputInfoFormatter(value,row,index){
	 var PLRowid=row.DPLid || "";
	 var ULRowid=row.DParid || "";
	 var TradeNo=row.TradeNo || "";
	 var UpFlag=row.UpFlag || "";
	 var AdmDr =GV.m_AdmDr || "";
	 var DivDr=GV.m_DivDr || "";
	 var PrtDr=GV.m_PrtDr || ""; //+DingSH 20220614 
	 var nfhml="<span class='linkinfo' onclick='showInputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+","+"\""+index+"\""+","+"\""+PrtDr+"\""+")' style='text-align:center'>详情</span>";
	return nfhml;
}		    
function setOutputInfoFormatter(value,row,index)
{
     var PLRowid=row.DPLid || "";
	 var ULRowid=row.DParid || "";
	 var TradeNo=row.TradeNo || "";
	 var UpFlag=row.UpFlag || "";
	 //var AdmDr =row.AdmDr || "";
	 //var InDivDr=row.InDivDr || "";
	 var nfhml="<span class='linkinfo' onclick='showOutputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+")' style='text-align:center'>详情</span>";
	return nfhml;
}
function showInputJson(PLRowid,ULRowid,TradeNo,AdmDr,InDivDr,UpFag,index,PrtDr){
   $("#info").html("");
     var ckval=false;
     if((index)&&(GV.PortListDic.parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
	     ckval=true;
	     }

	//if((UpFag=="上传成功")||((UpFag=="上传失败")))
    if((UpFag=="上传成功")||(((UpFag=="上传失败"))&&(!ckval)))
	{
		var options={
		ClassName:"web.DHCINSUDataUL",
		MethodName:"GetPLInPutData",
		PLRowid: PLRowid,
		ULRowid: ULRowid,
		TradeNo: TradeNo
	   }
	}
	else
	{
	 var InsuType=GV.m_InsuType;
	 if(InsuType==""){InsuType="00A"}
	 var InputInfo=InsuType+"^"+TradeNo+"^"+GV.HOSPID+"^"+GV.m_USERID+"^0^^1^"+AdmDr+"^"+InDivDr+"^^"+PrtDr; //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID^optType^PrtDr^账单号
	var InArgType="STR"; //入参类型(JSON、STR)
	var OutArgType="JSON"     //出参格式(JSON,XML,STR)
	var options={
		ClassName:"INSU.OFFBIZ.BL.BIZ00A",
		MethodName:"InsuDataUL",
		InputInfo: InputInfo,
		InArgType: InArgType,
		OutArgType:OutArgType
		
	 }
	}
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",TradeNo+"-交易入参");
	$('#InfoWin').dialog("open");
}			
function showOutputJson(PLRowid,ULRowid,TradeNo,UpFag){
	$("#info").html("");
	var options={
		ClassName:"web.DHCINSUDataUL",
		MethodName:"GetPLOutPutData",
		PLRowid: PLRowid,
		ULRowid: ULRowid,
		TradeNo: TradeNo
	   }
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",TradeNo+"交易出参");
	$('#InfoWin').dialog("open");
}
function UpFlagStyle(value,row,index){
	if (value=="上传失败") return "color:red;";
	if (value=="上传成功") return "color:green;";
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
