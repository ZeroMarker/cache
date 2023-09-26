
var Split="" ;		// 拆分标志
var UNsplit="" ;	// 拆分标志	
var itmid="" ;
var createUser=""; 	// 创建人 dws 2017-02-24

$(function(){ 

	initCombobox();  /// 初始化combobox
	CustomEditor();  /// 自定义编辑器
	initParam();	 /// 初始化参数
	initDate();		 /// 初始化时间控件
	initTable();	 /// 初始化easyui datagrid
	initMethod();	 /// 初始化控件绑定的事件
	initDisTime();	 /// 配送日期默认当前
	
});

//初始化下拉框
function initCombobox()
{
	$('#disType').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",    
    	valueField:'id',    
    	textField:'text',
    	onChange: function () {
			 var rows = $("#datagrid").datagrid('getRows');
			 for ( var i = 0; i < rows.length; i++) {
		         $("#datagrid").datagrid('endEdit', i);
			} 
		},
		onSelect:function(option){
			LoadCheckItemList(option.id)
		}
	});
	$('#ApplayLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#RecLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusComboS&type="+1,// type 0: 陪送 ,1: 配送
		valueField:'id',    
	    textField:'text' 
	});
	
	$('#currLoca').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISGoodsRequest&MethodName=GetCurrLoca",
		valueField:'id',    
	    textField:'text',
	    mode:'remote',
	    panelHeight:"auto",  
	});
	
}
function CustomEditor()
{
	 $.extend($.fn.datagrid.defaults.editors, {
		combogrid: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
				//options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&Loc='+$('#recLoc').combobox('getValue');
				options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&type='+$('#disType').combobox('getValue');
				input.combogrid(options);
				return input;
			},
			destroy: function(target){
				$(target).combogrid('destroy');
			},
			getValue: function(target){
				return $(target).combogrid('getText');
			},
			setValue: function(target, value){
				$(target).combogrid('setValue', value);
				
			},
			resize: function(target, width){
				$(target).combogrid('resize',width);
			}
		}
	});
}

/*//保存配送申请
function save(flag)   ///保存配送申请时加参数  sufan 2018-03-22
{
	if(!$('#detail').form('validate')){
		return;	
	}
	var rows = $("#datagrid").datagrid('getRows');
	for ( var i = 0; i < rows.length; i++) {
         $("#datagrid").datagrid('endEdit', i);
	}
	var LocIDStringLength=$("#recLoc").combobox('getValues').length;
	if((LocIDStringLength>1)&&(Split=="Y"))
	{
		$.messager.confirm('确认', '确认要拆分成'+LocIDStringLength+'条申请单吗?', function(r){
		if (r){
				SplitSave(flag);
			}
		})
	}
	else{
		SplitSave(flag);
	}
	
	
}
//拆分保存
function SplitSave(flag)
{
	var UrgentFlag=""  ///加急标志
		$("input[type=checkbox][name=urgentFlag]").each(function(){
			if($(this).is(':checked')){
				UrgentFlag='Y';
			}else{
				UrgentFlag='N'
			}
		})	
		var tableData=$("#datagrid").datagrid('getRows');
		var ItmlistData = [];
		for(var i=0;i<tableData.length;i++){
			//var data=tableData[i].itmid+"^"+tableData[i].locid+"^"+tableData[i].qty;
			var data=tableData[i].itmid+"^"+tableData[i].qty;
			ItmlistData.push(data);
		}
		var ItmInfo=ItmlistData.join("$$");

		var REQCreateUser=LgUserID   
		var REQLocDr=LgCtLocID;		
		var REQRecLocDr=$("#recLoc").combobox('getValues');
		var REQRemarks=$("#remark").val();  
		var REQExeDate=$('#exeDate').datetimebox('getValue').split(" ")[0] 
		var REQExeTime=$('#exeDate').datetimebox('getValue').split(" ")[1]      
		var REQCreateDate=(new Date()).Format("yyyy-MM-dd")            
		var REQCreateTime=(new Date()).Format("hh:mm:ss");
		var REQDisType=$("#disType").combobox('getValue');
		var RequestDateList=REQCreateUser+"^"+REQLocDr+"^"+REQRecLocDr+"^"+REQRemarks+"^"+REQExeDate+"^"+REQExeTime+"^"+REQCreateDate+"^"+REQCreateTime+"^"+REQDisType+"^"+UrgentFlag;
		runClassMethod("web.DHCDISGoodsRequest",
					"saveReqString",
					{'mainStrings':RequestDateList,'subStr':ItmInfo,"flag":flag},
					function(data){
						if(data==0)
						{
							$.messager.alert('提示','保存成功');
							clearForm();
							search();
						}else{
							 $.messager.alert('提示','保存失败'+data)
							 $("#datagrid").datagrid('reload')
							} 
					},"json")
}*/

/// 保存配送申请
function save(flag)
{
	if(!$('#detail').form('validate')){
		return;	
	}
	var rows = $("#datagrid").datagrid('getRows');
	for (var i = 0; i < rows.length; i++) {
         $("#datagrid").datagrid('endEdit', i);
	}
	var REQCreateUser = LgUserID  			// 创建人 
	var REQLocDr = LgCtLocID;				// 申请科室
	var REQRemarks = $("#remark").val();  	// 备注
	var REQExeDate = $('#exeDate').datetimebox('getValue').split(" ")[0] 	// 配送日期
	var REQExeTime = $('#exeDate').datetimebox('getValue').split(" ")[1]    // 配送时间
	var REQCreateDate = (new Date()).Format("dd/MM/yyyy") 				    // 创建日期           
	var REQCreateTime = (new Date()).Format("hh:mm:ss");					// 创建时间   
	var REQDisType = $("#disType").combobox('getValue');					// 配送类型
	var UrgentFlag = $('#urgent').is(':checked')? "Y":"N";   				// 加急
	var Loction = LgCtLocID;												// 申请单位置
	var LoctionFlag = "1";													// 申请单位置标识
	var RequestDateList = REQCreateUser+"^"+REQLocDr+"^"+REQRemarks+"^"+REQExeDate+"^"+REQExeTime+"^"+REQCreateDate+"^"+REQCreateTime+"^"+REQDisType+"^"+UrgentFlag+"^"+Loction+"^"+LoctionFlag;
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var ReqdataList = [];
	for(var i=0;i<rowsData.length;i++){
		var ReqItm = rowsData[i].itm;     		// 配送项目
		var ReqItmId = rowsData[i].itmid;		// 配送项目ID
		var ItmQty = rowsData[i].qty;			// 配送项目数量
		var ReqRecLoc = rowsData[i].loc;		// 接收科室	
		var ReqRecLocId = rowsData[i].locid;	// 接收科室ID
		if(ReqItmId==undefined)
		{
			$.messager.alert("提示","第"+(rowsData.length-i)+"行配送项目为空！")
			return;
		}	
		if(ReqRecLocId==undefined)
		{
			$.messager.alert("提示","第"+(rowsData.length-i)+"行接收科室为空！")
			return;
		}			
		var ListData = ReqItmId +"^"+ ItmQty +"^"+ ReqRecLocId +"^"+ REQDisType;
			ListData= ListData +"#"+ RequestDateList;
		ReqdataList.push(ListData);
	} 
	ReqdataList = ReqdataList.join("$$");
	alert(ReqdataList)
	runClassMethod("web.DHCDISGoodsRequest","Save",{"ListData":ReqdataList,"flag":flag},function(jsonString){
		if ((jsonString < 0)&&(jsonString!="-15")){
			$.messager.alert("提示:","配送申请发送失败!，失败原因:"+jsonString);
		}else if(jsonString=="-15"){
			$.messager.alert('提示',"没有安排配送人员或无排班信息！"+jsonString);
			return;
			}else{
				var ReqDisIdStr=jsonString;
				//$.messager.alert('提示','保存成功');
				SendInfo(ReqDisIdStr)
				clearForm();
				search();
			}
	},'',false)
}

///发送消息到微信端
function SendInfo(ReqDisIdStr)
{
	runClassMethod("web.DHCDISGoodsRequest","SenDisInfo",{"ReqDisIdStr":ReqDisIdStr},function(data){
	
	},'',false)
}
/// 删除
function deleteRow(){
	select=$('#datagrid').datagrid('getSelected');
	if(null==select){
		$.messager.alert('提示','请选择');
		return;
	}
	var itm="";
	$.messager.confirm('确认', '确认要删除吗?', function(r){
	if (r){
		itmid="";
		index=$('#datagrid').datagrid('getRowIndex',select);
		$('#datagrid').datagrid('deleteRow',index);
		}
		var rows = $('#datagrid').datagrid('getChanges');
		for(var i=0;i<rows.length-1;i++){
	 	
    		var row = rows[i];
			if(itm=="")
			{
				itm=row.locid;
			}else{
				itm=itm+"^"+row.locid;
			}
		}
		$('#recLoc').combobox({    
    		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itm,    
    		valueField:'id',    
    		textField:'text',
    		mode:'remote'   
		});
	});
	
}

///增加
function addRow(){
	if($('#disType').combobox('getValue')==""){
		$.messager.alert("提示","请先选择配送类型")
		return;	
	}
	commonAddRow({datagrid:'#datagrid',value:{qty:1}})	
}

///单击事件
function onClickRow(index,row){
	
	var itmid = row.itmid;
	CommonRowClick(index,row,"#datagrid");
	///设置级联指针
	var ed=$("#datagrid").datagrid('getEditor',{index:index,field:'loc'});
	var unitUrl=LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+ itmid;
	$(ed.target).combobox('reload',unitUrl);
}

///配送项目赋值
function fillValue(rowIndex, rowData)
{
	var itmid = rowData.id;
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'itmid'});			//项目ID赋值
	$(ed.target).val(rowData.id);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'itm'});				//项目描述赋值
	$(ed.target).val(rowData.desc);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'loc'});				//获取科室下拉
	var url=LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itmid;	//加载科室下拉数据	
	$(ed.target).combobox('reload',url);										
}

///科室赋值
function fillLocValue(obj){
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'loc'});
	$(ed.target).combobox("setValue",obj.text);  						//设置科室ID
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'locid'});
	$(ed.target).val(obj.id);  							//设置科室ID
	
}

///清空
function clearForm(){
	//$('#detail').form('clear');
	$("#disType").combobox('clear');
	$('#datagrid').datagrid('loadData', { total: 0, rows: [] });
	//$("#form").html("")
}

//初始化参数
function initParam(){
	
	//用途：获取后台参数
	$.ajax({
		url:LINK_CSP,
		data:{
			"ClassName":"web.DHCDISAffirmStatus",
	        "MethodName":"GetParamByInit"
		},
		type:'get',
		async:false,
		dataType:'json',
		success:function (data){
			Params = data;    
		}
		})
		
	rowData="";   //选中行数据全局变量
}

//初始化时间框
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//初始化datagrid
function initTable(){
	
	var columns = [[
		{
	        field: 'REQ',
	        align: 'center',
            //title: 'mainRowID',
            hidden: true,
            width: 100
	    },  {
	        field: 'REQTypeID',
	        align: 'center',
	        //hidden: true,
            title: '任务类型ID',
            hidden: true,
            width: 100
	    },{
	        field: 'REQEmFlag',
	        align: 'center',
            title: '加急标志',
            hidden: true,
            width: 70
	    },{
	        field: 'REQCurStatus',
	        align: 'center',
            title: '当前状态',
            width: 70
	    }, {
            field: 'REQConfirmUser',
            align: 'center',
            title: '出科确认人',
            hidden: true,
            width: 50
        },{
            field: 'REQCreateDate',
            align: 'center',
            title: '申请日期',
            width: 80
        }, {
            field: 'REQCreateTime',
            align: 'center',
            title: '申请时间',
            width: 100
        }, {
            field: 'REQLocDr',
            align: 'center',
            hidden: true,
            title: '申请科室ID',
            width: 80
        },{
            field: 'REQLoc',
            align: 'center',
            title: '申请科室',
            width: 80
        }, {
            field: 'REQNo',
            align: 'center',
            title: '验证码',
            hidden:true,
            width: 100  
        }, {
            field: 'REQRecLocDr',
            align: 'center',
            hidden: true,
            title: '接收科室ID',
            width: 160
        }, {
            field: 'REQRecLoc',
            align: 'center',
            title: '接收科室',
            width: 160
        }, { 
            field: 'REQExeDate',
            align: 'center',
            title: '配送日期',
            width: 100 
        }, { 
            field: 'REQExeTime',
            align: 'center',
            title: '配送时间',
            width: 100 
        }, {
            field: 'REQRemarks',
            align: 'center',
            title: '备注',
            width: 100
        }
        ]]
        
    var param=getParam(); //获取参数
    $('#cspAccompStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequest&param='+param,
	    fit:true,
	    rownumbers:true,
	    fitColumns:true,
	    columns:columns,
	    pageSize:20, 		// 每页显示的记录条数
	    pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onSelect:function(Index, row){
	        rowData= row;
	    },
	    onUnselect:function (Index, row){
			rowData= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail();
			DisOrConComplete(row);
		},
	})
	$('#cspAccompStatusTb').datagrid({
		rowStyler:function(index,row){
				if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
				}
			}
		
	})
	
	var columnsdetail = [[
		{
	        field: 'ITM',
	        align: 'center',
	        title: '项目名称',
	        width: 250	        
        },/* {
            field: 'RECLOC',
            align: 'center',
            title: '去向',
            width: 200
        }, */{
            field: 'QTY',
            align: 'center',
            title: '数量',
            width: 200
        }
        ]]
		
	$('#cspAccompStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true
    })
    
}
///控制完成和确认完成按钮的隐藏和显示
function DisOrConComplete(obj)
{
	if(obj.REQRecLocDr == LgCtLocID)
	{
		$("#complete").hide();
		$("#exeBtn").show();
	}else{
			$("#exeBtn").hide();
			$("#complete").show();
		}
}
///单击查询明细
function ClickRowDetail(){
	var row =$("#cspAccompStatusTb").datagrid('getSelected');
	DisMainRowId=row.REQ; ///父id
	//alert(DisMainRowId)
	$('#cspAccompStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequestItm&req='+DisMainRowId
	});
	Q
	}
	
function initMethod(){
	
     $('#RegNo').bind('keypress',RegNoBlur);		//回车事件
     $('#verifiBtn').bind('click',verifiDis); 		//验证确认
     $('#exeBtn').bind('click',exeDis);       		//配送确认
 	 $('#undoBtn').bind('click',Undorequest);      	//撤销申请
 	 $('#printbarcode').bind('click',printbarcode); //打印条码
 	 $('#printyfbarcode').bind('click',printyfbarcode); //打印条码
 	 $('#complete').bind('click',complete);			//完成
 	 $('#GetGoods').bind('click',GetGoods);			//接收
 	 $('#givenconfirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
 	 
 	 $('#searchBtn').bind('click',search) 			//查找	
 	 
 	 $("#appraiseBtn").on('click',function(){
	 	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	 	//dws 2017-02-24 评价权限
		if((($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="已签收")||(($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="已评价")){
			runClassMethod("web.DHCDISAppraise","getAccPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					ScorePages(); //打开评价界面
				}
				else{
					$.messager.alert("提示","申请单创建人才可以评价!");
				}
			});
			
		}
		else{
			$.messager.alert("提示","请签收申请单后再评价!");
		}
	 })
	 
	 $("#particulars").on('click',function(){
	 	ParticularsPages();   					//详情
	 })
	 
	 
	 $("#unfiniBtn").on('click',function(){
	 	UndonePages();   						//未完成                  
	 })
	 
	 $("#disitemList").on("click",".checkbox",selectExaItem);    //配送项目选择事件
	 
	 
}


/*======================================================*/

//登记号回车事件
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("提示","登记号长度输入有误！")
		    $('#RegNo').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#RegNo").val(Regno);
    }
};

//查询
function search(){
	var Params=getParam(); //获取参数
	$('#cspAccompStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAccompStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}

//出库确认&出科确认
function verifiDis(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	createVertifyWin();
}
function createVertifyWin(){	
	if($('#confirmwin').is(":hidden")){
	   $('#confirmwin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	var option = {
		closed:"true"
	};
	new WindowUX('出科确认', 'confirmwin', '300', '180', option).Init();
	
}

///出库确认
function afterconfirm()
{
	var StatusCode=13
	
	var EmFlag=rowData.REQEmFlag
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	var UserCode=$('#givenconfirm').val();
	if(UserCode!=LgUserCode)
	{
		$.messager.alert("提示:","工号错误!")
		$('#givenconfirm').val('');
		return;
	}
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","确认成功！");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

//签收确认
function exeDis(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	if((rowData.REQCurStatus!="完成")){			//sufan 2018-03-22 控制确认当前状态
			$.messager.alert("提示","非完成状态的申请不允许此操作！")
			return;	
		}
	var statuscode="" ;
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")       //sufan 2018-03-22 按类型判断状态代码
	{
		statuscode="103";
	}
	var Relation=""
	var LocaFlag=""
	Relation=$("#currLoca").combobox("getValue");
	if(Relation==""){
		Relation=LgCtLocID;
		LocaFlag="1"
	}else{
		LocaFlag="0"
	}
	var datalist=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID+"#"+EmFlag;
	//alert(datalist)
	$.messager.confirm('配送确认','确认将改配送状态置为完成确认吗？',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":"","Relation":Relation,"RelaFlag":LocaFlag},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","确认成功！");
						}
					},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData=""
		}	
	})
}

// 撤销申请
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
	}
	var ReqID=rowData.REQ
	var StatusCode=104
	var ReqType=rowData.REQTypeID
	var CurStatus=rowData.REQCurStatus;
	if((CurStatus!="申请")){
		$.messager.alert("提示","申请状态的申请单才可以撤销！");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('确认','您确认要撤销该条申请单吗？',function(r){
		if(r){
			runClassMethod("web.DHCDISRequestCom","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
				if(data!=0){
					$.messager.alert("提示",data)
				}else{
					$.messager.alert("提示","撤销成功！")
				}
			},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData="";
		}	
	})
}


//详情弹出层页面
function ParticularsPages(mainRowID){
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'详情',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+rowData.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//评分弹出层界面
function ScorePages(){
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'评价',
			border:true,
			closed:"true",
			width:600,
			height:420,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 
	
	//iframe 定义
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+createUser+'&type='+rowData.REQTypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//未完成界面窗口
function UndonePages(){
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'未完成',
		border:true,
		closed:"true",
		width:600,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table请求参数
//return ：开始时间^结束时间^任务ID^接收科室^申请科室^状态
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var recLoc = $('#RecLoc').combobox('getValue');
	if(recLoc==undefined){
		recLoc=""
	}
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate + "^" + endDate + "^" + "" + "^" + recLoc + "^" + applayLocDr + "^" + affirmStatus;
}

function printbarcode()
{	
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	var ReqID=rowData.REQ;
	runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
			if((data==-1)||(data==-2)||(data=="")){
				$.messager.alert("提示:","条码有误!");
				return;
			}else {
					Print(data.split("^")[0]);
				}
		},'text',false)
}

function printyfbarcode()
{
	if((rowData=="")){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	var ReqID=rowData.REQ;
	runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
			if((data==-1)||(data==-2)||(data=="")){
				$.messager.alert("提示:","条码有误!");
				return;
			}else {
					Print(data.split("^")[1]);
				}
		},'text',false)
}
///常规
function Print(data){	
		       
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDIS_BarCode"); 
	
	var MyPara="DisCode"+String.fromCharCode(2)+data;
	MyPara=MyPara+"^PrintBarCode"+String.fromCharCode(2)+"*"+data+"*";
	MyPara=MyPara+"^BarCode"+String.fromCharCode(2)+data;
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");	
}

function complete()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	if(EmFlag=="Y")
	{
		$.messager.alert("提示:","加急任务不允许此操作!");
		return;
	}
	if(rowData.REQCurStatus!="已安排"){			//sufan 2018-03-22 控制确认当前状态
		$.messager.alert("提示:","非已安排状态不允许此操作!");
		return;
	}
	var statuscode=""
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")
	{
		statuscode="102"
	}
	var Relation=""
	var LocaFlag=""
	Relation=$("#currLoca").combobox("getValue");
	if(Relation==""){
		Relation=LgCtLocID;
		LocaFlag="1"
	}else{
		LocaFlag="0"
	}
	var datastr=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID;
	//alert(datastr)
	runClassMethod("web.DHCDISGoodsRequest","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"reason":"","Relation":Relation,"RelaFlag":LocaFlag},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");

		}else{
			$.messager.alert('错误',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
				
}

///判断是科室或中转站
function isCtLoc()
{
	var flag="";
	runClassMethod("web.DHCDISGoodsRequest","isCtLoc",{"LocDr":LgCtLocID},function(jsonString){
		flag=jsonString;
	},'text',false);
	return flag;
}

function GetGoods()
{
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("提示","保存成功！");

		}else{
			$.messager.alert('错误',jsonString);
			return;
		}s
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

///默认当前日期
function initDisTime()
{
	var now=new Date();			// 当前日期
	var y = now.getFullYear();	// 年
	var m = now.getMonth()+1;   // 月       
	var d = now.getDate(); 		// 日
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var hours = now.getHours();		// 时
	var minutes = now.getMinutes(); // 分
	var seconds	= now.getSeconds(); // 秒
	if (hours <= 9)
	{
		var hours="0" + hours;
		}
	if (minutes <= 9)
	{
		var minutes="0" + minutes;
		}
	if (seconds <= 9)
	{
		var seconds="0" + seconds;
		}
	var time = hours +":"+ minutes +":"+ seconds;
	var startdate = y + "-" + m + "-" + d;
	var nowtime = startdate +" "+ time;
	$("#exeDate").datetimebox("setValue",nowtime);	// 设置标本固定时间
}
/// 加载配送项目列表
function LoadCheckItemList(typeId){
	/// 初始化检查方法区域
	$("#disitemList").html('<tr><td style="width:20px"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCDISCommonDS","getDisItemByTypeId",{"TypeId":typeId},function(jsonString){
		if (jsonString != ""){
			
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemobj){	
	var htmlstr = '';
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="height:25px;"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" style="margin-left:10px;" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#disitemList").append(htmlstr+itemhtmlstr)
}
function selectExaItem()
{
	if ($(this).is(':checked')){
		var DisItmId = this.id;					/// 配送项目Id
		var DisItmDesc = $(this).parent().next().text(); 	/// 配送项目
		var ItemLocID="",ItemLoc="";
		runClassMethod("web.DHCDISCommonDS","ItmLocCombo",{"itmid":DisItmId},function(jsonString){
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].id;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)	
		if(ItemLocID=="")
		{
			$.messager.alert("提示","接收科室为空");
			return false;
		}
		var rowobj={itmid:DisItmId, itm:DisItmDesc, qty:"1", loc:ItemLoc, locid:ItemLocID}
		$("#datagrid").datagrid('appendRow',rowobj);
	}else{
		
	   	
	   }
}