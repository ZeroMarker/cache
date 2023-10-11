var addRule={xpath:"1",op1Desc:"1",op1:"3"};
var $URL="web.DHCENS.STBLL.UTIL.PageLoad.cls?";
var conLen=0,rwoData;
$(function(){
	//初始化基本信息
	//Init();
	//加载方法列表
	loadMethod();
	//加载参数列表
	loadParameter();
	//加载功能列表
	loadFunction();
	

})
	
	


//初始化基本信息
function Init(){      
	$('input[name="sercode"]').val(getServiceInfo('sercode'));
	$('input[name="sername"]').val(getServiceInfo('sername'));
	$('input[name="serdesc"]').val(getServiceInfo('serdesc'));
	$('input[name="serflag"]').switchbox("setValue",getServiceInfo('serflag'))
	$('input[name="serhost"]').val(getServiceInfo('serhost'));
	$('input[name="seraddr"]').val(getServiceInfo('seraddr'));
	$('input[name="serport"]').val(getServiceInfo('serport'));
	$('input[name="serprov"]').combobox('setValue',getServiceInfo('serprov'));
	$('input[name="serUsr"]').val(getServiceInfo('serUsr'));
	$('input[name="serPwd"]').val(getServiceInfo('serPwd'));
	$('input[name="ssl"]').val(getServiceInfo('ssl'));
}
	
//点击保存基本信息
$("#saveUpd").on("click",function(){
	alert("save")
	//console.log("form",$("form").serialize())
	var sercode=$('input[name="sercode"]').val();
	var sername=$('input[name="sername"]').val();
	var serdesc=$('input[name="serdesc"]').val();
	var serflag=$('input[name="serflag"]').switchbox("getValue");
	var serhost=$('input[name="serhost"]').val();
	var seraddr=$('input[name="seraddr"]').val();
	var serport=$('input[name="serport"]').val();
	var serprov=$('input[name="serprov"]').combobox('getValue');
	var serUsr=$('input[name="serUsr"]').val();
	var serPwd=$('input[name="serPwd"]').val();
	var ssl=$('input[name="ssl"]').val();
	
	var input="OptType=M&busCode=BUS001&action=EditSG&sercode="+sercode+"&sername="+sername+"&serdesc="+serdesc+"&serflag="+serflag+"&serhost="+serhost+"&seraddr="+seraddr+"&serport="+serport+"&serprov="+serprov+"&serUsr="+serUsr+"&serPwd="+serPwd+"&ssl="+ssl;
	$.ajax({ 
		type: "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?"+input,
		/*参数：action: EditMG
			 sernasp: 
			sercode: REG0001
			methodcode: 
			paracode: 
			columndesc: MethodNote
			rowid: GetCurrentTime
			value: 1111
			busCode: BUS001
			OptType: M */
		dateType: "json",
		success: function(data){
			var dataInfo=data.replace(/[\r\n]/g,"^")
			var arr = new Array();
			arr = dataInfo.split("^^");
			var length=arr.length;
			var obj=eval('('+arr[length-1]+')');				
			if (obj.retvalue=="1") {  
				$.messager.alert('提示','保存成功');
			}else{  
				$.messager.alert('提示',obj.retinfo);
			}
		}
	}) 
})

	
//点击返回
$("#returnUpd").on("click",function(){
	$("body.service").empty().load("enswebserviceregist.csp");
})
	
	
	
//加载方法列表
/*step3-SOAP 服务方法*/
function loadMethod(){
	$HUI.datagrid("#MethodGrid-upd",{
		//title:'服务方法',
	    pagination:true,
	    afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
	    fit:true,
	    nowrap: false,        
	    fitCloumns: true,
	    minimized:false,
	    striped:true,
	    cache:false, 
	    method:'get',
	    url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=MethodList&sernasp=&sercode=服务代码&busCode=总线代码",
	    singleSelect:true,
		columns:[[   
		    {field:'MethodDesc',title:'方法名称',sortable:true,width:"20%",editor:{type:"text"}},   
		    {field:'MethodNote',title:'方法描述',sortable:true,width:"20%",editor:{type:"text"}}, 
		    {field:'MethodStatus',title:'方法状态',width:"20%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: 'Y',desc: '运行'},{value: 'N',desc: '停用'}]}},
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.status=="Y") {
			    		status="<span class='icon icon-run'>运行</span>";
		    		}
		    		else {
			    		status="<span class='icon icon-unuse'>停用</span>";
		    		}
		    		return status;
			 	}   
			},  
		    {field:'ReturnVal',title:'返回值类型',width:"20%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: '%String',desc: '字符串'},{value: '%GlobalCharacterStream',desc: '字符流'}]}}},
		    {field:'btnUpdate',title:'操作',sortable:true,width:"20%",
		    	formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("MethodGrid",'+(rowIndex)+')">编辑</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("MethodGrid",'+(rowIndex)+')">保存</a>';
	                return editBtn+saveBtn
	                
		    	}		    
		    },
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			rowData["busCode"]=
			//更新本行数据
			$.ajax({ 
				type: "POST",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData&"+rowData,
				/*参数：action: EditMG
					 sernasp: 
					sercode: REG0001
					methodcode: 
					paracode: 
					columndesc: MethodNote
					rowid: GetCurrentTime
					value: 1111
					busCode: BUS001
					OptType: M */
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length;
					var obj=eval('('+arr[length-1]+')');				
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','保存成功');
					}else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			}) 
		},
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		} ,
	    onLoadSuccess:function(data){  
	        $('.editcls').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'保存',plain:true,iconCls:'icon-save'});
	    }
	})
}



//加载方法列表
function loadParameter(){
	/* step3-SOAP参数编辑*/
	$HUI.datagrid("#ParameterGrid-upd",{
		//title:'参数编辑',
	    pagination:true,
	    afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
	    fit:true,
	    nowrap: false,        
	    fitCloumns: true,
	    minimized:false,
	    striped:true,
	    cache:false, 
	    method:'get',
	    url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ParameterList&sernasp=&sercode=REG0001&mthcode=GetCurrentTime&busCode=BUS001',
	    singleSelect:true,
		columns:[[   
		    {field:'id',title:'参数名称',sortable:true,width:"25%",editor:{type:"text"}},   
		    {field:'code',title:'数据类型',sortable:true,width:"25%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: '%String',desc: '字符串'},{value: '%GlobalCharacterStream',desc: '字符流'}]}}}, 
		    {field:'desc',title:'参数描述',width:"25%",editor:{type:"text"}},  
		    {field:'pPackage',title:'操作',width:"25%",
		    	formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("ParameterGrid",'+(rowIndex)+')">编辑</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("ParameterGrid",'+(rowIndex)+')">保存</a>';
	                return editBtn+saveBtn
		    	}	
		    },
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			//更新本行数据
			$.ajax({ 
				type: "POST",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveParamsData&"+rowData,
				/* action: EditPG
				sernasp: hsb
				sercode: REG0001
				methodcode: GetCurrentTime
				paracode: 
				columndesc: ParameterDesc
				rowid: Input
				value: Input
				busCode: BUS001
				OptType: M */
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length;
					var obj=eval('('+arr[length-1]+')');				
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','保存成功');
					}else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			}) 
		},
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		} ,
	    onLoadSuccess:function(data){  
	        $('.editcls').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'保存',plain:true,iconCls:'icon-save'});
	    }	
	})
}
	
	
//加载功能列表
function loadFunction(){
	/* step3-SOAP功能配置*/
	$HUI.datagrid("#FunctionGrid-upd",{
		//title:'功能配置',
	    pagination:true,
	    afterPageText:'页,共{pages}页', beforePageText:'第', displayMsg:'显示{from}到{to}条，共{total}条',
	    fit:true,
	    nowrap: false,        
	    fitCloumns: true,
	    minimized:false,
	    striped:true,
	    cache:false, 
	    method:'get',
	    url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=FunctionList&sernasp=hsb&sercode=REG0001&mthcode=GetCurrentTime&paracode=Input&busCode=BUS001&category=ESB&input=^^SOAP',
	    singleSelect:true,
		columns:[[   
		    {field:'id',title:'功能代码',sortable:true,width:40,editor:{type:"text"}},   
		    {field:'code',title:'功能描述',sortable:true,width:120,editor:{type:"text"}}, 
		    {field:'desc',title:'出参格式',width:300,formatter:function(value,rowData,rowIndex){
			    	var uploadBtn = '<a href="#this" class="upload" onclick="upLoadOutFormat('+rowData+','+(rowIndex)+')">上传</a>';
			    	var settingBtn = '<a href="#this" class="setting" onclick="settingRule('+rowData+','+(rowIndex)+')">设置</a>';
	                return uploadBtn+settingBtn
		    	}	
		    },  
		    {field:'pPackage',title:'操作',width:230,
			    formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("FunctionGrid",'+(rowIndex)+')">编辑</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("FunctionGrid",'+(rowIndex)+')">保存</a>';
	                return editBtn+saveBtn
		    	}	
			},
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			//更新本行数据
			$.ajax({ 
				type: "POST",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveFuncData&"+rowData,
				/* action: EditFG
				sernasp: hsb
				sercode: REG0001
				methodcode: GetCurrentTime
				paracode: Input
				columndesc: FunctionCode
				rowid: 1
				value: 11
				busCode: BUS001
				OptType: M */
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length;
					var obj=eval('('+arr[length-1]+')');				
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','保存成功');
					}else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			}) 
		},
		//toolbar:"#FunctionTar",
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		} ,
	    onLoadSuccess:function(data){  
	        $('.editcls').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'保存',plain:true,iconCls:'icon-save'});
	    }
	})
}


//启用编辑
function regUpdateRow(tabId,rowindex){
	var regTb = $("#"+tabId).datagrid();
	regTb.beginEdit(rowindex);
	regTb.selectRow(rowindex);
	
}
//结束编辑
function regSaveRow(tabId,rowindex){
	var regTb = $("#"+tabId).datagrid();
	regTb.endEdit(rowindex);	
}

//新增功能
function functionAdd(){
	var functionCode = $("#functionCode").val();//功能代码
	var functionDesc = $("#functionDesc").val();//功能描述
	var inputStr = functionCode+"^"+functionDesc;
	//新增
	$.ajax({ 
		type: "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveFunc&"+inputStr,
		/* action=saveFunc&sercode=REG0001&mthcode=GetCurrentTime&paracode=Input&funccode=1&funcnote=1&busCode=BUS001&OptType=M */
		dateType: "json",
		success: function(data){
			var dataInfo=data.replace(/[\r\n]/g,"^")
			var arr = new Array();
			arr = dataInfo.split("^^");
			var length=arr.length;
			var obj=eval('('+arr[length-1]+')');				
			if (obj.retvalue=="1") {  
				$.messager.alert('提示','保存成功');
			}else{  
				$.messager.alert('提示',obj.retinfo);
			}
		}
	}) 
}

//查询功能
function functionSearch(){
	var inputStr=("#editfunSearch").searchbox("getValue");
	$('#FunctionGrid').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=FunctionList&input="+inputStr,method:"get"});
	$('#FunctionGrid').datagrid('load');
}


/******规则设置-start********/
	
	
//点击设置-规则
$("#addd").on("click",function(){
	console.log("1",'1')
	$('#settingRule').dialog('open');
	settingRule();	
})


function settingRule(data,index){
	rwoData=data;
	getRuleTree();
	getRuleList();
}

//获取格式树
function getRuleTree(){
	//返回数据格式字段部分修改："name":"Bundle"换成"text":"Bundle";"open":"true"换成 "state":"open|closed"；去掉isParent字段
	$('#getRuleTree').tree({
		/* url:$URL+"action=GetGetParaTreeFromXML",
		method:"post", */
	 	data: [{
			"id": 1,
			"text": "1",
			"state": "open",
			"children": [{
				"id": 11,
				"text": "Node 11",
				"children": [{
					"id": 111,
					"text": "Node 111",
					"children": [{
						"id": 1111,
						"text": "Node 1111",
					},{
						"id": 1112,
						"text": "Node 1112",
					}],
					
				}, {
					"id": 112,
					"text": "Node 112"
				}]
			}, {
				"id": 12,
				"text": "Node 12"
			}]
		}, {
			"id": 2,
			"text": "2",
			"state": "open",
			"children": [{
				"id": 21,
				"text": "Node 21",
				"children": [{
					"id": 211,
					"text": "Node 211"
				}, {
					"id": 212,
					"text": "Node 212",
					"children": [{
						"id": 2121,
						"text": "Node 2121"
					}, {
						"id": 2122,
						"text": "Node 2122"
					}]
				}]
			}, {
				"id": 22,
				"text": "Node 22"
			}]
		}, {
			"id": 3,
			"text": "3",
			"state": "closed",
			"children": [{
				"id": 31,
				"text": "Node 31",
				"children": [{
					"id": 311,
					"text": "Node 311"
				}, {
					"id": 312,
					"text": "Node 312"
				}]
			}, {
				"id": 32,
				"text": "Node 32"
			}]
		}, {
			"id": 4,
			"text": "4"
		}], 
		lines:true,
		autoNodeHeight:true,
		onSelect:function(node){
			//获取当前节点路径
			if(!(node.children==undefined)){
				addRule.op1Desc="/"+node.text;
				addRule.op1=node.text;
				addRule.xpath=addRule.op1Desc+"/^";
			}else{
				var textArr=node.text.split("(");
				addRule.op1Desc="/@"+textArr[0];
				addRule.op1=textArr[0];
				addRule.xpath=addRule.op1Desc+"^";
			}
			
			var parent=$("#getRuleTree").tree("getParent",node.target);
			var parentext="";
			while(parent){
				parentext=parent.text;
				addRule.op1Desc="/"+parentext+addRule.op1Desc;
				addRule.xpath="/"+parentext+addRule.xpath;
				parent=$("#getRuleTree").tree("getParent",parent.target);
				console.log("addRule",addRule);
			}
		}
	})
}



//获取条件列表
function getRuleList(){
	/* $.ajax({ 
		type: "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url: $URL+"action=GetRtnRule&",
		
		dateType: "json",
		success: function(data){ */
			var data={"service":{"serType":"SOAP","serCode":"REG0001","mthCode":"GetCurrentTime","parCode":"Input","funCode":"11"},"condition":[{"join":"AND","op1":"value","operator":"=","op2":"1","xpath":"/Bundle/id/@value^","op1Desc":"/Bundle/id/@value"},{"join":"AND","op1":"Bundle","operator":"=","op2":"2","xpath":"/Bundle/^","op1Desc":"/Bundle"},{"join":"AND","op1":"value","operator":"=","op2":"3","xpath":"/Bundle/identifier/value/@value^","op1Desc":"/Bundle/identifier/value/@value"},{"join":"AND","op1":"meta","operator":"=","op2":"4","xpath":"/Bundle/meta/^","op1Desc":"/Bundle/meta"}]};
			var str="";
			var condition=data.condition;
			//条件总数
			conLen=condition.length;
			for(var i=0;i<conLen;i++){
				var joinv=condition[i].join;
				var op1Descv=condition[i].op1Desc;
				var xpathv=condition[i].xpath;
				var operatorv=condition[i].operator;
				var op1v=condition[i].op1;
				var op2v=condition[i].op2;
				
				if(i==0){
					var join='<span>如果</span>';
				}else{
					var join='<span><select class="hisui-combobox" name="join-'+i+'"><option value="AND" >并且</option><option value="OR">或者</option></select></span>';
				}
				var op1Desc='<span><input class="textbox" name="propertyDesc-'+i+'"/></span>';
				var xpath='<span class="hidden"><input type="textbox" name="xpath-'+i+'" /></span>';
				var operator='<span><select class="hisui-combobox" name="operator-'+i+'"><option value="=">等于</option><option value="!=">不等于</option><option value=">">大于</option><option value="<">小于</option><option value="[">包含</option></select></span>';
				var op1='<span class="hidden"><input type="textbox" name="property-'+i+'"/></span>';
				var fuzhi='<span><a href="#" class="hisui-linkbutton" >赋值</a></span>'
				var op2='<span><input class="textbox" name="value-'+i+'"/></span>';
				var icon='<span><a href="#" class="hisui-linkbutton" iconCls="icon-no" /></span>';
				var xmlStr='<div class="rule rule-"'+i+'">'+join+op1Desc+op1+xpath+fuzhi+operator+op2+icon+'</div>';
				$(".rulelist").append(xmlStr);
				$.parser.parse();
				//赋值
				if(i>0) $("select[name='join-"+i+"']").combobox('setValue',joinv);
				$("input[name='propertyDesc-"+i+"']").val(op1Descv);
				$("input[name='property-"+i+"']").val(op1v);
				$("input[name='xpath-"+i+"']").val(xpathv);
				$("select[name='operator-"+i+"']").combobox('setValue',operatorv);
				$("input[name='value-"+i+"']").val(op2v);
				
			}
		/*}
	}) */
}

	
//点击添加条件
$("#addRule").on("click",function(){
	console.log("conLen",conLen)
	if(conLen==0){
		var join='<span>如果</span>';
	}else{
		var join='<span><select class="hisui-combobox" name="join-'+conLen+'"><option value="AND" >并且</option><option value="OR">或者</option></select></span>';
	}
	var op1Desc='<span><input class="textbox" name="propertyDesc-'+conLen+'"/></span>';
	var xpath='<span class="hidden"><input type="textbox" name="xpath-'+conLen+'" /></span>';
	var operator='<span><select class="hisui-combobox" name="operator-'+conLen+'"><option value="=">等于</option><option value="!=">不等于</option><option value=">">大于</option><option value="<">小于</option><option value="[">包含</option></select></span>';
	var op1='<span class="hidden"><input type="textbox" name="property-'+conLen+'"/></span>';
	var fuzhi='<span><a href="#" class="hisui-linkbutton" name="fuzhi-'+conLen+'" >赋值</a></span>'
	var op2='<span><input class="textbox" name="value-'+conLen+'"/></span>';
	var icon='<span><a href="#" class="hisui-linkbutton" iconCls="icon-no" /></span>';
	var xmlStr='<div class="rule rule-"'+conLen+'">'+join+op1Desc+op1+xpath+fuzhi+operator+op2+icon+'</div>';
	$(".rulelist").append(xmlStr);
	//赋值
	$("input[name='propertyDesc-"+conLen+"']").val(addRule.op1Desc);
	$("input[name='property-"+conLen+"']").val(addRule.op1);
	$("input[name='xpath-"+conLen+"']").val(addRule.xpath);
	$.parser.parse();  
	conLen++;
})	


//点击保存规则
$("#saveRule").on("click(",function(){
	console.log("saveRule","saveRule")
	var condition=[];
	for(var i=0;i<conLen;i++){
		if(i>0) var join=$("select[name='join-"+i+"']").combobox('getValue');
		var op1Desc=$("input[name='propertyDesc-"+i+"']").val();
		var op1=$("input[name='property-"+i+"']").val();
		var xpath=$("input[name='xpath-"+i+"']").val();
		var operator=$("select[name='operator-"+i+"']").combobox('getValue');
		var op2=$("input[name='value-"+i+"']").val();
		condition[i]={"join":join,"op1":op1,"operator":operator,"op2":op2,"xpath":xpath,"op1Desc":op1Desc};
	}
	var inputJson={"service":{"serviceType":"SOAP","mthcode":"","parCode":"","ftnCode":"",},"condition":condition};
	$.ajax({ 
		type: "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url: $URL+"action=saveRtn&",
		/* action=saveFunc&sercode=REG0001&mthcode=GetCurrentTime&paracode=Input&funccode=1&funcnote=1&busCode=BUS001&OptType=M */
		dateType: "json",
		success: function(data){
			$.messager("info",data);
		}
	})
})	



//初始化规则设置模态框
$HUI.dialog('#settingRule',{
	title: '规则设置',
    width: 1000,
    height: 400,
    top:100,
    left:300,
    padding:10,
    closed: true,
    cache: false,
    modal: true,
    iconCls:'icon-batch-cfg',
    resizable:true,
    modal:true,
    onClose:function(){
	     $(".rulelist").empty();
	}
})


/**********规则设置-end**********/

/**********文件上传-start**********/

$("#upload").on('click',function(){
	
	$("#uploadFormat").dialog("open");
})
//初始化文件上传模态框
$HUI.dialog('#uploadFormat',{
	title: '上传出参格式模板',
    width: 1000,
    height: 400,
    top:100,
    left:300,
    padding:10,
    closed: true,
    cache: false,
    modal: true,
    iconCls:'icon-upload',
    resizable:true,
    modal:true,
})

$HUI.filebox('#fileInput', {
	width:350,
	buttonText:'选择',
	prompt:'请选择文件',
	plain:true,
	onChange:function(newValue, oldValue){
		console.log("value",newValue, oldValue);
		var files=$("#fileInput").filebox("files");
		console.log("files",files)
		
		
		//添加相关文档详情卡片
	}
})

//点击清除
$("#delFile").on('click',function(){
	$("#fileInput").filebox("reset");
	
})


//点击上传
$("#upload").on('click',function(){
	$(this).linkbutton('disable');
	uploadFormat();
	
})

//点击取消上传
$("#cancelUpd").on('click',function(){
	$("#fileInput").filebox("reset");
})


//上传文件
function uploadFormat(){
	//上传成功后隐藏上传，取消上传，删除，并清空文件框
}

/*  <link href="../scripts_lib/basal/bootstrap_3.3.5/css/fileinput.min.css" rel="stylesheet">
 <script type="text/javascript" src="../scripts_lib/plug/ajaxfileupload/ajaxfileupload.js"></script>
 <script type="text/javascript" src="../scripts_lib/basal/bootstrap_3.3.5/js/fileinput.min.js"></script>
 <script type="text/javascript" src="../scripts_lib/basal/bootstrap_3.3.5/js/fileinput_locale_zh.js"></script>
 
<script type="text/javascript" src="../scripts_lib/plug/jquery-ui-1.12.1/jquery-ui.min.js"></script> */




/**********文件上传-end**********/
