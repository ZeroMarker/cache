var addRule={xpath:"1",op1Desc:"1",op1:"3"};
var $URL="web.DHCENS.STBLL.UTIL.PageLoad.cls?";
var conLen=0,rwoData;
$(function(){
	//��ʼ��������Ϣ
	//Init();
	//���ط����б�
	loadMethod();
	//���ز����б�
	loadParameter();
	//���ع����б�
	loadFunction();
	

})
	
	


//��ʼ��������Ϣ
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
	
//������������Ϣ
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
		/*������action: EditMG
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
				$.messager.alert('��ʾ','����ɹ�');
			}else{  
				$.messager.alert('��ʾ',obj.retinfo);
			}
		}
	}) 
})

	
//�������
$("#returnUpd").on("click",function(){
	$("body.service").empty().load("enswebserviceregist.csp");
})
	
	
	
//���ط����б�
/*step3-SOAP ���񷽷�*/
function loadMethod(){
	$HUI.datagrid("#MethodGrid-upd",{
		//title:'���񷽷�',
	    pagination:true,
	    afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
	    fit:true,
	    nowrap: false,        
	    fitCloumns: true,
	    minimized:false,
	    striped:true,
	    cache:false, 
	    method:'get',
	    url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=MethodList&sernasp=&sercode=�������&busCode=���ߴ���",
	    singleSelect:true,
		columns:[[   
		    {field:'MethodDesc',title:'��������',sortable:true,width:"20%",editor:{type:"text"}},   
		    {field:'MethodNote',title:'��������',sortable:true,width:"20%",editor:{type:"text"}}, 
		    {field:'MethodStatus',title:'����״̬',width:"20%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: 'Y',desc: '����'},{value: 'N',desc: 'ͣ��'}]}},
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.status=="Y") {
			    		status="<span class='icon icon-run'>����</span>";
		    		}
		    		else {
			    		status="<span class='icon icon-unuse'>ͣ��</span>";
		    		}
		    		return status;
			 	}   
			},  
		    {field:'ReturnVal',title:'����ֵ����',width:"20%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: '%String',desc: '�ַ���'},{value: '%GlobalCharacterStream',desc: '�ַ���'}]}}},
		    {field:'btnUpdate',title:'����',sortable:true,width:"20%",
		    	formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("MethodGrid",'+(rowIndex)+')">�༭</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("MethodGrid",'+(rowIndex)+')">����</a>';
	                return editBtn+saveBtn
	                
		    	}		    
		    },
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			rowData["busCode"]=
			//���±�������
			$.ajax({ 
				type: "POST",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData&"+rowData,
				/*������action: EditMG
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
						$.messager.alert('��ʾ','����ɹ�');
					}else{  
						$.messager.alert('��ʾ',obj.retinfo);
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
	        $('.editcls').linkbutton({text:'�༭',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'����',plain:true,iconCls:'icon-save'});
	    }
	})
}



//���ط����б�
function loadParameter(){
	/* step3-SOAP�����༭*/
	$HUI.datagrid("#ParameterGrid-upd",{
		//title:'�����༭',
	    pagination:true,
	    afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
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
		    {field:'id',title:'��������',sortable:true,width:"25%",editor:{type:"text"}},   
		    {field:'code',title:'��������',sortable:true,width:"25%",editor:{type:"combobox",options:{valueField: 'value',textField: 'desc',data: [{value: '%String',desc: '�ַ���'},{value: '%GlobalCharacterStream',desc: '�ַ���'}]}}}, 
		    {field:'desc',title:'��������',width:"25%",editor:{type:"text"}},  
		    {field:'pPackage',title:'����',width:"25%",
		    	formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("ParameterGrid",'+(rowIndex)+')">�༭</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("ParameterGrid",'+(rowIndex)+')">����</a>';
	                return editBtn+saveBtn
		    	}	
		    },
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			//���±�������
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
						$.messager.alert('��ʾ','����ɹ�');
					}else{  
						$.messager.alert('��ʾ',obj.retinfo);
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
	        $('.editcls').linkbutton({text:'�༭',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'����',plain:true,iconCls:'icon-save'});
	    }	
	})
}
	
	
//���ع����б�
function loadFunction(){
	/* step3-SOAP��������*/
	$HUI.datagrid("#FunctionGrid-upd",{
		//title:'��������',
	    pagination:true,
	    afterPageText:'ҳ,��{pages}ҳ', beforePageText:'��', displayMsg:'��ʾ{from}��{to}������{total}��',
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
		    {field:'id',title:'���ܴ���',sortable:true,width:40,editor:{type:"text"}},   
		    {field:'code',title:'��������',sortable:true,width:120,editor:{type:"text"}}, 
		    {field:'desc',title:'���θ�ʽ',width:300,formatter:function(value,rowData,rowIndex){
			    	var uploadBtn = '<a href="#this" class="upload" onclick="upLoadOutFormat('+rowData+','+(rowIndex)+')">�ϴ�</a>';
			    	var settingBtn = '<a href="#this" class="setting" onclick="settingRule('+rowData+','+(rowIndex)+')">����</a>';
	                return uploadBtn+settingBtn
		    	}	
		    },  
		    {field:'pPackage',title:'����',width:230,
			    formatter:function(value,rowData,rowIndex){
			    	var editBtn = '<a href="#this" class="editcls" onclick="regUpdateRow("FunctionGrid",'+(rowIndex)+')">�༭</a>';
			    	var saveBtn = '<a href="#this" class="savecls" onclick="regSaveRow("FunctionGrid",'+(rowIndex)+')">����</a>';
	                return editBtn+saveBtn
		    	}	
			},
		]],
		onAfterEdit:function(rowIndex, rowData, changes){
			//���±�������
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
						$.messager.alert('��ʾ','����ɹ�');
					}else{  
						$.messager.alert('��ʾ',obj.retinfo);
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
	        $('.editcls').linkbutton({text:'�༭',plain:true,iconCls:'icon-edit'});
	        $('.savecls').linkbutton({text:'����',plain:true,iconCls:'icon-save'});
	    }
	})
}


//���ñ༭
function regUpdateRow(tabId,rowindex){
	var regTb = $("#"+tabId).datagrid();
	regTb.beginEdit(rowindex);
	regTb.selectRow(rowindex);
	
}
//�����༭
function regSaveRow(tabId,rowindex){
	var regTb = $("#"+tabId).datagrid();
	regTb.endEdit(rowindex);	
}

//��������
function functionAdd(){
	var functionCode = $("#functionCode").val();//���ܴ���
	var functionDesc = $("#functionDesc").val();//��������
	var inputStr = functionCode+"^"+functionDesc;
	//����
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
				$.messager.alert('��ʾ','����ɹ�');
			}else{  
				$.messager.alert('��ʾ',obj.retinfo);
			}
		}
	}) 
}

//��ѯ����
function functionSearch(){
	var inputStr=("#editfunSearch").searchbox("getValue");
	$('#FunctionGrid').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=FunctionList&input="+inputStr,method:"get"});
	$('#FunctionGrid').datagrid('load');
}


/******��������-start********/
	
	
//�������-����
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

//��ȡ��ʽ��
function getRuleTree(){
	//�������ݸ�ʽ�ֶβ����޸ģ�"name":"Bundle"����"text":"Bundle";"open":"true"���� "state":"open|closed"��ȥ��isParent�ֶ�
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
			//��ȡ��ǰ�ڵ�·��
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



//��ȡ�����б�
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
			//��������
			conLen=condition.length;
			for(var i=0;i<conLen;i++){
				var joinv=condition[i].join;
				var op1Descv=condition[i].op1Desc;
				var xpathv=condition[i].xpath;
				var operatorv=condition[i].operator;
				var op1v=condition[i].op1;
				var op2v=condition[i].op2;
				
				if(i==0){
					var join='<span>���</span>';
				}else{
					var join='<span><select class="hisui-combobox" name="join-'+i+'"><option value="AND" >����</option><option value="OR">����</option></select></span>';
				}
				var op1Desc='<span><input class="textbox" name="propertyDesc-'+i+'"/></span>';
				var xpath='<span class="hidden"><input type="textbox" name="xpath-'+i+'" /></span>';
				var operator='<span><select class="hisui-combobox" name="operator-'+i+'"><option value="=">����</option><option value="!=">������</option><option value=">">����</option><option value="<">С��</option><option value="[">����</option></select></span>';
				var op1='<span class="hidden"><input type="textbox" name="property-'+i+'"/></span>';
				var fuzhi='<span><a href="#" class="hisui-linkbutton" >��ֵ</a></span>'
				var op2='<span><input class="textbox" name="value-'+i+'"/></span>';
				var icon='<span><a href="#" class="hisui-linkbutton" iconCls="icon-no" /></span>';
				var xmlStr='<div class="rule rule-"'+i+'">'+join+op1Desc+op1+xpath+fuzhi+operator+op2+icon+'</div>';
				$(".rulelist").append(xmlStr);
				$.parser.parse();
				//��ֵ
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

	
//����������
$("#addRule").on("click",function(){
	console.log("conLen",conLen)
	if(conLen==0){
		var join='<span>���</span>';
	}else{
		var join='<span><select class="hisui-combobox" name="join-'+conLen+'"><option value="AND" >����</option><option value="OR">����</option></select></span>';
	}
	var op1Desc='<span><input class="textbox" name="propertyDesc-'+conLen+'"/></span>';
	var xpath='<span class="hidden"><input type="textbox" name="xpath-'+conLen+'" /></span>';
	var operator='<span><select class="hisui-combobox" name="operator-'+conLen+'"><option value="=">����</option><option value="!=">������</option><option value=">">����</option><option value="<">С��</option><option value="[">����</option></select></span>';
	var op1='<span class="hidden"><input type="textbox" name="property-'+conLen+'"/></span>';
	var fuzhi='<span><a href="#" class="hisui-linkbutton" name="fuzhi-'+conLen+'" >��ֵ</a></span>'
	var op2='<span><input class="textbox" name="value-'+conLen+'"/></span>';
	var icon='<span><a href="#" class="hisui-linkbutton" iconCls="icon-no" /></span>';
	var xmlStr='<div class="rule rule-"'+conLen+'">'+join+op1Desc+op1+xpath+fuzhi+operator+op2+icon+'</div>';
	$(".rulelist").append(xmlStr);
	//��ֵ
	$("input[name='propertyDesc-"+conLen+"']").val(addRule.op1Desc);
	$("input[name='property-"+conLen+"']").val(addRule.op1);
	$("input[name='xpath-"+conLen+"']").val(addRule.xpath);
	$.parser.parse();  
	conLen++;
})	


//����������
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



//��ʼ����������ģ̬��
$HUI.dialog('#settingRule',{
	title: '��������',
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


/**********��������-end**********/

/**********�ļ��ϴ�-start**********/

$("#upload").on('click',function(){
	
	$("#uploadFormat").dialog("open");
})
//��ʼ���ļ��ϴ�ģ̬��
$HUI.dialog('#uploadFormat',{
	title: '�ϴ����θ�ʽģ��',
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
	buttonText:'ѡ��',
	prompt:'��ѡ���ļ�',
	plain:true,
	onChange:function(newValue, oldValue){
		console.log("value",newValue, oldValue);
		var files=$("#fileInput").filebox("files");
		console.log("files",files)
		
		
		//�������ĵ����鿨Ƭ
	}
})

//������
$("#delFile").on('click',function(){
	$("#fileInput").filebox("reset");
	
})


//����ϴ�
$("#upload").on('click',function(){
	$(this).linkbutton('disable');
	uploadFormat();
	
})

//���ȡ���ϴ�
$("#cancelUpd").on('click',function(){
	$("#fileInput").filebox("reset");
})


//�ϴ��ļ�
function uploadFormat(){
	//�ϴ��ɹ��������ϴ���ȡ���ϴ���ɾ����������ļ���
}

/*  <link href="../scripts_lib/basal/bootstrap_3.3.5/css/fileinput.min.css" rel="stylesheet">
 <script type="text/javascript" src="../scripts_lib/plug/ajaxfileupload/ajaxfileupload.js"></script>
 <script type="text/javascript" src="../scripts_lib/basal/bootstrap_3.3.5/js/fileinput.min.js"></script>
 <script type="text/javascript" src="../scripts_lib/basal/bootstrap_3.3.5/js/fileinput_locale_zh.js"></script>
 
<script type="text/javascript" src="../scripts_lib/plug/jquery-ui-1.12.1/jquery-ui.min.js"></script> */




/**********�ļ��ϴ�-end**********/
