/**
 * FileName: insudataulmain.js
 * Anchor: wty
 * Date: 2021-03-15
 * Description: 医保数据上传管理
 * 按单个人上传所有接口数据
 */
var GV={
	 mainDtlList:null,
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
	 m_ddv:null
	 }
$(document).ready(function () {		
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initDataDtlList();
	initHOSPID();
	initInsuType();
});

function initQueryMenu() {
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
				copyText($("#copyInfo").text());
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
GV.mainDtlList=	$HUI.datagrid('#mainDtlList', {
		fit: true,
		border: false,
		striped: true,
		//singleSelect: true,
		selectOnCheck: true,
	   //checkOnSelect: false,
		autoRowHeight: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		view: detailview,
		detailFormatter: function(rowIndex, rowData) {
			return "<div style=\"padding:2px;\"><table class=\"ddv\"></table></div>"
		},
		onExpandRow: function(rowIndex, rowData) {
			GV.m_PARID=rowData.Did || "";
			GV.m_AdmDr=rowData.AdmDr;
			GV.m_DivDr=rowData.DivDr;
			GV.m_OptType=$('#OptType').combobox('getValue');
			GV.m_PrtDr=rowData.TPrtDr;
		    //GV.m_HospDr=$('#HOSPID').combobox('getValue');
		    GV.m_HospDr=rowData.THospID;
			//var $ddv = GV.mainDtlList.getRowDetail(rowIndex).find("table.ddv");
			GV.m_InsuType=rowData.TInsuType;
			GV.m_ddv= GV.mainDtlList.getRowDetail(rowIndex).find("table.ddv");
			//	$ddv.datagrid({
			GV.m_ddv.datagrid({
				width: 800,
				height: 'auto',
				bodyCls: 'panel-body-gray',
				//singleSelect: true,
				loadMsg: '',
				rownumbers: true,
				pageList: [5,10,30],
				pageSize: 5,
				pagination: true,
			    selectOnCheck: false,
		        checkOnSelect: false,
			columns: [[
			    {
		
					title: 'ck1',
					field: 'ck1',
					checkbox: true
				},
			      {
					title: '交易编号',
					field: 'TradeNo',
					align: 'center',
					width: 80
				}, {
					title: '交易名称',
					field: 'TradeDesc',
					align: 'center',
					width: 150
				},{
					title: '上传标志',
					field: 'UpFlag',
					align: 'center',
					width: 80,
					styler:UpFlagStyle
				},
				{
				   field:'InptPara',
				   title:'交易入参',
				   width:80,
				   formatter:setInputInfoFormatter  //DingSH 20220331
				 },
			    {
				    field:'OutPara',
			        title:'交易出参',
			        width:80,
			        formatter:setOutputInfoFormatter
			    }
				, {
					title: '上传人',
					field: 'OptUser',
					align: 'center',
					width: 80
				}, {
					title: '上传日期',
					field: 'OptDate',
					align: 'center',
					width: 100
				}
				, {
					title: '上传时间',
					field: 'OptTime',
					align: 'center',
					width: 100
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
				url: $URL,
				queryParams: {
					//PARID='+RowId+"&OptType="+$('#OptType').combobox('getValue')+"&HospDr="+$('#HOSPID').combobox('getValue'),
					ClassName: 'web.DHCINSUDataUL',
		            QueryName: 'QueryPortList',
		            PARID:GV.m_PARID,
		            OptType:GV.m_OptType,
		            HospDr:GV.m_HospDr,
		            InsuType:GV.m_InsuType
				},
				onLoadSuccess: function(data) {
					setTimeout(function() {
						GV.mainDtlList.fixDetailRowHeight(rowIndex);    //用来固定当详细内容加载时的行高度
					}, 0);
				},
				onSelect:function(index,row){
					 GV.DPLRowid = row.DPLid;
					 GV.DPLInfno = row.TradeNo;
					},
				onUnselect:function(index,row) {
					   GV.DPLRowid = "";
					   GV.DPLInfno = "";
					}
				
			});
			GV.mainDtlList.fixDetailRowHeight(rowIndex);    //用来固定当详细内容加载时的行高度
		},
		onCollapseRow:function(rowIndex, rowData)
		 {
			//alert(31)
			GV.DPLRowid="";
			GV.DPLInfno="";
			GV.m_ddv=null;
			GV.m_InsuType="";
		 },
		columns: [[{
		
					title: 'ck',
					field: 'ck',
					checkbox: true
				},
		         {
					title: '上传标志',
					field: 'TOptFlag',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						//btnstr="<a type='button'  onclick=\"EprListDetail(\'" + row.Did + "\')\" style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						btnstr="<a type='button'   style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						return btnstr						
					}
				}, {
					title: '姓名',
					field: 'TPatName',
					align: 'center',
					width: 80
				},{
					title: '登记号',
					field: 'TPatRegNo',
					align: 'center',
					width: 100
				},  {
					title: '病案号',
					field: 'TMedcasNo',
					align: 'center',
					width: 100
				}, {
					title: '住院科室',
					field: 'TDepDesc',
					align: 'center',
					width: 120
				}, {
					title: '入院日期',
					field: 'TAdmDate',
					align: 'center',
					width: 100
				}, {
					title: '出院日期',
					field: 'TOutDate',
					align: 'center',
					width: 100
				}, {
					title: '结算日期',
					field: 'TDisDate',
					align: 'center',
					width: 100
				},{
					title: '发票状态',
					field: 'TPrtActStus',
					align: 'center',
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
					align: 'center',
					width: 120
				}, {
					title: '医保登记id',
					field: 'TInsuZylsh',
					align: 'center',
					width: 160,
					hidden:true
				}, {
					title: '医保结算id',
					field: 'TInsuDjlsh',
					align: 'center',
					width: 160,
					hidden:true
				}
				, {
					title: '上传人员',
					field: 'TOpter',
					align: 'center',
					width: 100
				}, {
					title: '上传日期',
					field: 'TOptDate',
					align: 'center',
					width: 150
				}, {
					title: '医保类型',
					field: 'TInsuType',
					align: 'center',
					width: 80
				}, {
					title: 'Rowid',
					field: 'Did',
					align: 'center',
					width: 60
				}, {
					title: 'AdmDr',
					field: 'AdmDr',
					align: 'center',
					width: 60
				}, {
					title: 'DivDr',
					field: 'DivDr',
					align: 'center',
					width: 60
				}, {
					title: '就诊类型',
					field: 'TAdmType',
					align: 'center',
					width: 80
				}, {
					title: '医院',
					field: 'THospID',
					align: 'center',
					width: 60
				}, {
					title: '发票Dr',
					field: 'TPrtDr',
					align: 'center',
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
		            
		            
		            
					}
					
			
			
		
	});
}

function loadDataDtlList() {
	setUpbtnAbled("")
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
		HOSPID:$('#HOSPID').combobox('getValue') || '',
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
	      	param.HospDr = $('#HOSPID').combobox('getValue');
	     },
	    columns:[[   
	        {field:'Code',title:'数据ID',width:40},  
	        {field:'Desc',title:'描述',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function()
	    {	
	      $('#mainDtlList').datagrid({data:[]});	    
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				//$('#InsuType').combogrid('grid').datagrid('selectRow',0);
				$('#InsuType').combogrid('grid').datagrid('selectRecord','00A'); //可修改
		    }
		}
	}); 	
}


/*
 不再使用 修改 DingSH 20220411 
*/
/*function EprListDetail(RowId){
	websys_showModal({
		url: 'insudataportlistdtl.csp?PARID='+RowId+"&OptType="+$('#OptType').combobox('getValue')+"&HospDr="+$('#HOSPID').combobox('getValue'),
		title: '上传交易详细信息',
		iconCls: 'icon-w-list',
		height:600,
		width:800
	});		
}*/

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
			if((GV.m_ddv)&&(Infno)) {
				GV.m_ddv.datagrid("reload")
				}
		}
			
			     
			
		 				
	}	
}

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
	 var nfhml="<span class='linkinfo' onclick='showInputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+","+"\""+index+"\""+","+"\""+PrtDr+"\""+")'>详情</span>";
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
	 var nfhml="<span class='linkinfo' onclick='showOutputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+")'>详情</span>";
	return nfhml;
}
function showInputJson(PLRowid,ULRowid,TradeNo,AdmDr,InDivDr,UpFag,index,PrtDr){
   $("#info").html("");
     var ckval=false;
     if((index)&&(GV.m_ddv.parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
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
	 var InputInfo=InsuType+"^"+TradeNo+"^"+$('#HOSPID').combobox('getValue')+"^"+GV.m_USERID+"^0^^1^"+AdmDr+"^"+InDivDr+"^^"+PrtDr; //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID^optType^PrtDr^账单号
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
