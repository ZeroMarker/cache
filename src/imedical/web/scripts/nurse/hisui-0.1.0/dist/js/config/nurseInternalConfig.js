var HospEnvironment=true;
var hospId=session['LOGON.HOSPID'];
$(function () {
	/**
    * @description: ��ʼ������
    */
	var treeSelect="leftTemplateTreeAll";
	function initUI() {
		if (typeof GenHospComp == "undefined") {
			HospEnvironment=false;
		}
		if(HospEnvironment){
			initHosp();
		}else{
			var hospDesc=tkMakeServerCall("NurMp.DHCNURTemPrintLInk","GetHospDesc",session['LOGON.HOSPID'])
			$("#_HospList").val(hospDesc)
			$('#_HospList').attr('disabled',true);
			//$("#_HospListLabel").css("display","none")
	    	//$("#_HospList").css("display","none")
		}
		initCondition();
		initEvent();
		initTable();
		initLeftTemplatesTree("",true);
		initBindGrid()
	}
	function initHosp(){
		
		var hospComp = GenHospComp("Nur_IP_DHCNurEmrBind",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
		hospId=$HUI.combogrid('#_HospList').getValue()
		hospComp.options().onSelect = function(){
			if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
			initLeftTemplatesTree($HUI.searchbox('#search').getValue(),$HUI.switchbox('#searchType').getValue())
		};  
		hospId = hospComp.options().value;
	}
	
	function initEvent(){
		$('#clearscreen').bind("click",clearScreen)
		$('#exportAll').bind("click",exportDataAll)
		$('#searchType').bind("change",searchTypeChange)
	}
	function searchTypeChange(){
		
		var searchCode=$HUI.searchbox('#search').getValue();
		if(searchCode!=""){
			var seachTyp=$HUI.switchbox('#searchType').getValue();
			initLeftTemplatesTree(searchCode,seachTyp)
		}
		
	}
	function initCondition() {
		$('#search').searchbox({
			searcher: function(value) {
				var seachTyp=$HUI.switchbox('#searchType').getValue();
				initLeftTemplatesTree(value,seachTyp)
			},
			prompt: 'ģ����,EmrCode,��������'
		});
		
		
		$HUI.combobox('#frequency', {
			valueField: 'value',
			textField: 'value',
			editable:false,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "���һ��"},
                { value: "all"},
				{ value: "1"},
                { value: "2"},
				{ value: "3"},
                { value: "4"},
				{ value: "5"}
            ]
		});
		$HUI.combobox('#category', {
			valueField: 'value',
			textField: 'value',
			editable:false,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "�ı�"},
                { value: "����ѡ��"},
				{ value: "����ֵ"},
                { value: "���"}
            ]
		});
		$HUI.combobox('#tranMode', {
			valueField: 'value',
			textField: 'value',
			editable:false,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "����"},
                { value: "����"}
            ]
		});
		
		$HUI.combobox('#emrElement', {
			valueField: 'element',
			textField: 'element',
			multiple:true,
			rowStyle:'checkbox',
			selectOnNavigation:false,
			//panelHeight:"auto",
			editable:false,
			url: $URL + '?ClassName=NurMp.DHCNurEmrBind&QueryName=GetEmrElement&ResultSetType=array&code=',
		});
		
	}
	function initTable(){
		$HUI.tabs("#treeTab",{
			
			onSelect:function(title){
				// $.messager.popover({type:'info',msg:'�л�����'+title+'��'}); 
				if(title=="ȫ��"){
					treeSelect="leftTemplateTreeAll";		
				}else{
					treeSelect="leftTemplateTreeBind";		
				}	
			}
		});
	}
	/**
  	* @description:  ��ʼ��ģ��
    */
	
	var selectNode=null;
    function initLeftTemplatesTree(searchCode,searchType) {
		
		$HUI.tree('#leftTemplateTreeAll', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.DHCNurEmrBind",
					MethodName: "GetInternalConfigTree",
					Parr: "^^"+searchCode+"^"+searchType,
					hospId:hospId
				}, function(data) {
					success(data);
					if(selectNode){
						var nsub = $('#leftTemplateTreeAll').tree('find', selectNode.id);
						if(nsub){
							$("#leftTemplateTreeAll").tree('select', nsub.target);
						}
					}
				});
			},
			autoNodeHeight: true,
			onClick: function (node) {
				selectNode=node;
				treeNodeClick(node)
			},
		    onContextMenu : function(e,node){
		    }
		});
		
		
		$HUI.tree('#leftTemplateTreeBind', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.DHCNurEmrBind",
					MethodName: "GetInternalConfigTree",
					Parr: "^Y^"+searchCode+"^"+searchType,
					hospId:hospId
				}, function(data) {
					success(data);
					if(selectNode){
						var nsub = $('#leftTemplateTreeBind').tree('find', selectNode.id);
						if(nsub){
							$("#leftTemplateTreeBind").tree('select', nsub.target);
						}
					}
					
				});
			},
			autoNodeHeight: true,
			onClick: function (node) {
				selectNode=node;
				treeNodeClick(node)
			},
		    onContextMenu : function(e,node){
		    }
		});
	}
	function initBindGrid(){
		
		$('#bindGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.DHCNurEmrBind',
				QueryName: 'FindBindData',
				code: '',
				hospId:hospId
			},
			nowrap: false,
			toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: addDataItem
				}, {
					iconCls: 'icon-edit',
					text: '�޸�',
					handler: editDataItem
				}, {
					iconCls: 'icon-remove',
					text: 'ɾ��',
					handler: deleteDataItem
				}, {
					iconCls: 'icon-export',
					text: '������ǰ',
					handler: exportData,
				}, {
					iconCls: 'icon-import',
					text: '����',
					handler: importData
				}
			],
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 15,
			pageList: [15,30,60,120],
			onClickRow: bindGridClickRow,
		});
	}
	
	function treeNodeClick(node){
		clearScreen();
		//var aaa=$HUI.tree('#leftTemplateTree').getSelected()
		//var aaa=$('#leftTemplateTree').tree('getSelected')  
		if(node.isLeaf!=0){
			$('#emrElement').combobox({url: $URL + '?ClassName=NurMp.DHCNurEmrBind&QueryName=GetEmrElement&ResultSetType=array&code='+node.guid });
			$('#bindGrid').datagrid('reload', {
				ClassName: 'NurMp.DHCNurEmrBind',
				QueryName: 'FindBindData',
				code: node.guid,
				hospId:hospId
			});
		}else{
			$('#emrElement').combobox({url: $URL + '?ClassName=NurMp.DHCNurEmrBind&QueryName=GetEmrElement&ResultSetType=array&code=' });
			
		}
	}
	function bindGridClickRow(rowIndex, rowData){
		setCommonInfo(rowData);
	}
	
	function setCommonInfo(rowData) {
		for (var item in rowData) {
			
	        var domID = "#" + item;
	        if (domID === '#frequency'||domID === '#category'||domID === '#tranMode') {
	        	$(domID).combobox('setValue', rowData[item]);
	        } else if(domID === '#emrElement'){
				$(domID).combobox('setValues', tranArray(rowData[item]));
			}else {
	        	$(domID).val(rowData[item]);
	        }
	    }
	}
	function tranArray(str){
		var oldArray=str.split(",")
		var newArray=[];
		for(var i=0;i<oldArray.length/3;i++){
			newArray[newArray.length]=oldArray[i*3]+","+oldArray[i*3+1]+","+oldArray[i*3+2];
		}
		return newArray
	}
	function exportData(){
		var node=$HUI.tree('#'+treeSelect).getSelected()
		if(!node||node.isLeaf==0){
			$.messager.popover({msg:'��ѡ��һ��ģ��!',type:'error'});
			return;
		}
		var rtn = $cm({
			dataType:'text',
			ResultSetType:"Excel",
			ExcelName:node.text+"�ڲ�����", 
			ClassName:"NurMp.DHCNurEmrBind",
			QueryName:"ExportBindData",
			guid:node.guid
		},false);
		
		//var rtn = tkMakeServerCall("websys.Query","ToExcel","�ڲ�����","NurMp.DHCNurEmrBind","ExportBindData","");
		location.href = rtn;
	}
	
	function exportDataAll(){
		var rtn = $cm({
			dataType:'text',
			ResultSetType:"Excel",
			ExcelName:"ȫ���ڲ�����", 
			ClassName:"NurMp.DHCNurEmrBind",
			QueryName:"ExportBindData",
			guid:""
		},false);
		
		//var rtn = tkMakeServerCall("websys.Query","ToExcel","�ڲ�����","NurMp.DHCNurEmrBind","ExportBindData","");
		location.href = rtn;
		
	}
	function deleteDataItem(){
		var node=$HUI.tree('#'+treeSelect).getSelected()
		if(!node||node.isLeaf==0){
			//$.messager.popover({msg:'��ѡ��ģ��!',type:'error'});
			//return;
		}
		var bindRow=$('#bindGrid').datagrid("getSelected");
		if(!bindRow){
			$.messager.popover({msg:"��ѡ��һ�����ݣ�",type:'error'});
			return;
		}
		
		$m({
			ClassName:'NurMp.DHCNurEmrBind',
			MethodName:'delete',
			par:bindRow.id
		},function(result){
			clearScreen();
			$.messager.popover({msg:"ɾ���ɹ�",type:"success"});
			$('#bindGrid').datagrid('reload');
			$HUI.tree('#leftTemplateTreeAll').reload();
			$HUI.tree('#leftTemplateTreeBind').reload();
		});
	}
	function editDataItem(){
		var node=$HUI.tree('#'+treeSelect).getSelected()
		if(!node||node.isLeaf==0){
			//$.messager.popover({msg:'��ѡ��ģ��!',type:'error'});
			//return;
		}
		var bindRow=$('#bindGrid').datagrid("getSelected");
		if(!bindRow){
			$.messager.popover({msg:"��ѡ��һ�����ݣ�",type:'error'});
			return;
		}
		var name = $('#name').val();
		var className = $('#className').val();
		var methodName = $('#methodName').val();
		var tranMode = $('#tranMode').combobox('getText');
		var emrElement = $('#emrElement').combobox('getText');
		var frequency = $('#frequency').combobox('getText');
		var category = $('#category').combobox('getText');
		if(category==""){
			$.messager.popover({msg:'���Ͳ���Ϊ��!',type:'error'});
			return;
		}
		if(name==""){
			$.messager.popover({msg:'���Ʋ���Ϊ��!',type:'error'});
			return;
		}
		if(className==""){
			//$.messager.popover({msg:'��������Ϊ��!',type:'error'});
			//return;
		}
		if(methodName==""){
			//$.messager.popover({msg:'��������Ϊ��!',type:'error'});
			//return;
		}
		if(tranMode==""){
			$.messager.popover({msg:'���䷽ʽ����Ϊ��!',type:'error'});
			return;
		}
		if(emrElement==""){
			$.messager.popover({msg:'����Ԫ�ز���Ϊ��!',type:'error'});
			return;
		}
		if(frequency==""){
			$.messager.popover({msg:'Ƶ�β���Ϊ��!',type:'error'});
			return;
		}
		var parr=frequency+"^"+name+"^"+emrElement+"^"+node.guid+"^"+category+"^"+tranMode+"^"+className+"^"+methodName;
		$m({
			ClassName:'NurMp.DHCNurEmrBind',
			MethodName:'save',
			parr:parr,
			id:bindRow.id,
			hospId:hospId
		},function(result){
			clearScreen();
			$.messager.popover({msg:"����ɹ�",type:"success"});
			$('#bindGrid').datagrid('reload');
		});
	}
	function clearScreen(){
		$('#name').val("");
		$('#className').val("");
		$('#methodName').val("");
		$('#tranMode').combobox('setValue', "");
		$('#emrElement').combobox('setValue', "");
		$('#frequency').combobox('setValue', "");
		$('#category').combobox('setValue', "");
	}
    function addDataItem(){
		var node=$HUI.tree('#'+treeSelect).getSelected()
		if(!node||node.isLeaf==0){
			$.messager.popover({msg:'��ѡ��ģ��!',type:'error'});
			return;
		}
		var name = $('#name').val();
		var className = $('#className').val();
		var methodName = $('#methodName').val();
		var tranMode = $('#tranMode').combobox('getText');
		var emrElement = $('#emrElement').combobox('getText');
		var frequency = $('#frequency').combobox('getText');
		var category = $('#category').combobox('getText');
		if(category==""){
			$.messager.popover({msg:'���Ͳ���Ϊ��!',type:'error'});
			return;
		}
		if(name==""){
			$.messager.popover({msg:'���Ʋ���Ϊ��!',type:'error'});
			return;
		}
		if(className==""){
			//$.messager.popover({msg:'��������Ϊ��!',type:'error'});
			//return;
		}
		if(methodName==""){
			//$.messager.popover({msg:'��������Ϊ��!',type:'error'});
			//return;
		}
		if(tranMode==""){
			$.messager.popover({msg:'���䷽ʽ����Ϊ��!',type:'error'});
			return;
		}
		if(emrElement==""){
			$.messager.popover({msg:'����Ԫ�ز���Ϊ��!',type:'error'});
			return;
		}
		if(frequency==""){
			$.messager.popover({msg:'Ƶ�β���Ϊ��!',type:'error'});
			return;
		}
		var parr=frequency+"^"+name+"^"+emrElement+"^"+node.guid+"^"+category+"^"+tranMode+"^"+className+"^"+methodName;
		
		$m({
			ClassName:'NurMp.DHCNurEmrBind',
			MethodName:'save',
			parr:parr,
			id:'',
			hospId:hospId
		},function(result){
			clearScreen();
			$.messager.popover({msg:"����ɹ�",type:"success"});
			$('#bindGrid').datagrid('reload');
			$HUI.tree('#leftTemplateTreeAll').reload();
			$HUI.tree('#leftTemplateTreeBind').reload();
		});
	}
	/**
	 * @description ����
	 */
	function importData() {
		$('#importDialog').dialog({
			title: '�����ļ�',
			width: 400,
			height: 200,
			closed: false,
			modal: true,
			buttons: [{
				text:'����',
				handler: importHandler,
			},{
				text:'ȡ��',
				handler:function(){
					$('#importDialog').dialog("close");
				}
			}]

		});
	}
	/**
	 * @description ����
	 */
	function importHandler() {
		var filePath = $("input[name=file]").val();
		if ((filePath.indexOf(".xls") == "-1")&(filePath.indexOf(".xlsx") == "-1")&(filePath.indexOf(".csv") == "-1")) {
		   $.messager.alert('��ʾ',"��ѡ��excel����ļ���.csv�ļ���");
		   $.messager.progress('close'); 
		   return;
		}
		var realFilePath = filePath.replace(/\\/g, "\\\\");
		if(!!realFilePath){
			importExcel(realFilePath,filePath.indexOf(".csv") == "-1");
			$.messager.popover({msg:'�������!',type:'success'});
			$('#importDialog').dialog("close");
			
		}else{
			$.messager.popover({msg:'��ѡ���ļ���',type:'info'});
			return;
		}
	}
	/**
	 * @description ����Excel
	 */
	function importExcel(realFilePath,isExcel){
		try{
		    var oXL = new ActiveXObject("Excel.application"); 
		    var oWB = oXL.Workbooks.open(realFilePath);
		    oWB.worksheets(1).select(); 
		    var oSheet = oWB.ActiveSheet;
			var par="";
			var parID=""
			var failStr=""
		    for(var i=2;i<1000;i++) {
				var emrElement= oSheet.Cells(i,1).value
				var name= oSheet.Cells(i,2).value
				var guid= oSheet.Cells(i,3).value
				var frequency= oSheet.Cells(i,4).value
				var category= oSheet.Cells(i,5).value
				var tranMode= oSheet.Cells(i,6).value
				var className= oSheet.Cells(i,7).value
				var methodName= oSheet.Cells(i,8).value
				
				
				if(emrElement==undefined||emrElement=="null"){emrElement="";}
				if(name==undefined||name=="null"){name="";}
				if(guid==undefined||guid=="null"){guid="";}
				if(frequency==undefined||frequency=="null"){frequency="";}
				if(category==undefined||category=="null"){category="";}
				if(tranMode==undefined||tranMode=="null"){tranMode="";}
				if(className==undefined||className=="null"){className="";}
				if(methodName==undefined||methodName=="null"){methodName="";}
				emrElement=emrElement.replace(/��/g,",");
				
				if(emrElement==""||name==""||guid==""||frequency==""||category==""||tranMode==""){break;}
				if(guid.length!=32) continue;
				var parr=frequency+"^"+name+"^"+emrElement+"^"+guid+"^"+category+"^"+tranMode+"^"+className+"^"+methodName;
				
				
				var result=tkMakeServerCall("NurMp.DHCNurEmrBind","save",parr,"",hospId);
				if(result.indexOf("-1")>-1){
					failStr=failStr+name+":"+result.split("^")[1]+guid+";"
					
				}
		    }
			if(failStr!=""){
				alert(failStr)
			}
		}catch(e){
			alert(e.message)
		}
	    oXL.Quit();
		$('#bindGrid').datagrid("reload");
	}
	initUI();
});