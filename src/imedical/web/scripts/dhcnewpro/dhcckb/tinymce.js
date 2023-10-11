var dicParref = getParam("dicParref");  
var subEditRow = 0; 
var valeditRow = 0;
var attrType = "";  //属性类别
debugger;
  tinymce.init({
	//readonly:1,
    selector: '#tinydemo2',
    //skin:'oxide-dark',
    language:'zh-Hans',
    menubar: false,
    plugins: 'print preview searchreplace autolink directionality visualblocks visualchars fullscreen image link media template code codesample table charmap hr pagebreak nonbreaking anchor insertdatetime advlist lists wordcount imagetools textpattern help emoticons autosave   autoresize  savehtml ',
    //toolbar: 'code undo redo restoredraft |  forecolor backcolor bold italic underline strikethrough |  formatselect fontselect fontsizeselect  |  table image  insertdatetime print preview  fullscreen| alignleft aligncenter alignright alignjustify outdent indent  lineheight | savehtml |bullist numlist | blockquote subscript superscript removeformat',
    toolbar:'code undo redo restoredraft |forecolor backcolor bold italic underline strikethrough |alignment|formatselect fontselect fontsizeselect  |tabletools|listtools|scripttools|savehtml  ',
    toolbar_groups: {
        formatting: {
            text: '文字格式',
            tooltip: 'Formatting',
            items: 'bold italic underline | superscript subscript',
        },
        alignment: {
            icon: 'align-left',
            tooltip: 'alignment',
            items: 'alignleft aligncenter alignright alignjustify outdent indent  lineheight',
        },
        tabletools: {
            icon: 'image',
            tooltip: 'image',
            items: 'table image  insertdatetime   fullscreen',
        },
        listtools: {
            icon: 'checklist',
            tooltip: 'bullist',
            items: 'bullist numlist',
        },
        scripttools: {
            icon: 'superscript',
            tooltip: 'superscript',
            items: 'blockquote subscript superscript removeformat',
        },
        diytools: {
	        text: '文字格式',
            icon: 'diytools',
            tooltip: 'diytools',
            items: 'savehtml print preview',
        },
    },
    
    fontsize_formats: '12px 14px 16px 18px 24px 36px 48px 56px 72px',
    font_formats: '微软雅黑=Microsoft YaHei,Helvetica Neue,PingFang SC,sans-serif;苹果苹方=PingFang SC,Microsoft YaHei,sans-serif;宋体=simsun,serif;仿宋体=FangSong,serif;黑体=SimHei,sans-serif;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;',
    content_css : '../scripts/dhcnewpro/dhcckb/css/main.css',
    contextmenu: false, 
    setup: function (editor) {
        editor.on('keydown', function (event) {
            if (event.keyCode === 13) {
                event.shiftKey = true;
            }
        });
    },
    init_instance_callback : "Initbutton" ,
    images_upload_handler: function (blobInfo, succFun, failFun) {
	    var formData = new FormData();
	    var file = new File([blobInfo.blob()],blobInfo.blob().name);
	    formData.append('files', file);
	    formData.append('ClassName', "web.DHCCKBImageFile");
	    formData.append('MethodName', "save");
	    
	    $.ajax({
			url: "dhcckb.brokerfile.csp", //'http://10.1.30.144:8004/example/uploadFiles',
			type: 'POST',
			dataType:'json',
			cache: false,
			data: formData,
			multipart: true, //上传文件三剑客
			processData: false,
			contentType: false,
			success: function(res) {
				if (res.code == 200) {
					succFun(res.location);
				} else {
					failFun('HTTP Error: ' + res.code);
               		return;	
				}
			},
			error: function(res) {
				
			}
		});
	    return;  
    },
    
    autosave_ask_before_unload: false,
    statusbar: false,
});

//初始化界面加载
function initPageDefault()
{
	debugger;
		InitButton();
		InitAttrValueList();
		//setTimeout(InitCombobox,2000);

}



function InitCombobox()
{
	debugger;   //测试
	//在此添加引用hisui
    var pobj=document.getElementById('tinydemo2_ifr').contentWindow.document.getElementsByTagName('head')[0]
    
     /*<link rel="stylesheet" type="text/css" href="../scripts_lib/hisui-0.1.0/dist/css/hisui.min.css" />
	 <script type="text/javascript" src="../scripts_lib/hisui-0.1.0/dist/js/jquery-1.11.3.min.js" charset="utf-8"></script>
	 <script type="text/javascript" src="../scripts_lib/hisui-0.1.0/dist/js/jquery.hisui.min.js" charset="utf-8"></script>
	 */
    //var textobj=document.createElement("<link rel='stylesheet' type='text/css' href='../scripts_lib/hisui-0.1.0/dist/css/hisui.min.css' /><script type='text/javascript' src='../scripts_lib/hisui-0.1.0/dist/js/jquery-1.11.3.min.js' charset='utf-8'></script><script type='text/javascript' src='../scripts_lib/hisui-0.1.0/dist/js/jquery.hisui.min.js' charset='utf-8'></script>");
    var textobj=document.createElement("<link rel='stylesheet' type='text/css' href='../scripts_lib/hisui-0.1.0/dist/css/hisui.min.css' />")
    
    pobj.appendChild(textobj)
        
        
	var cbox = $HUI.combobox("#GenerNameFormProp",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'css',text:'CSS语言'},{id:'html',text:'HTML语言'}
			,{id:'c',text:'C语言'},{id:'cplus',text:'C++语言'}
			,{id:'java',text:'JAVA语言'},{id:'cache',text:'M语言'}
			,{id:'sql',text:'结构化查询语言'}
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
}

function InitButton()
{
	$("#add_btn").bind("click",AddBtn);		// 弹窗中新增
	
	$("#del_btn").bind("click",DelBtn);		// 弹窗中删除	


	///树的查找
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    //var desc=$HUI.searchbox("#myChecktreeDesc").getValue();		   
			//$("#mygrid").treegrid("search", desc)	
	   		QueryTreeList();
	    }	   
	});	
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	       var EntLinkId="38";
	       var parref=getQueryVariable("ID");
	       var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
           var url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+EntLinkId+"&EntyId="+parref+"&chkFlag="+this.value+"&param="+param;
		   $("#mygrid").tree('options').url =encodeURI(url);
		   $('#mygrid').tree('reload');
        }
     });
}

function GetCombobox(){
		var obj=tinymce.activeEditor.dom.get('GenerNameFormProp');
		var id = obj.id;
		var typea = obj.className;
		var type =obj.getAttribute("data-type")
		
		var index=obj.selectedIndex; //序号，取当前选中选项的序号
		var val = obj.options[index].value;
		alert(type)
		
}

function getDOM(){
	var cc=tinymce.activeEditor.dom.get(attrCode)
	}


function Initbutton(editor){
//界面元素都设为不可编辑 shy 2022-10-12	
tinymce.activeEditor.getBody().setAttribute('contenteditable', false);
//通用名新增
	var index=0
	editor.dom.get('GenerNameFormPropbtn').addEventListener('click', function () {
		debugger; 
		attrType="通用名";
		var ThisID=serverCall("web.DHCCKBCommon","GetGeneralFromData",{"MWToken":TOKEN})
		OpenWin(ThisID,"datagrid","GenerNameFormProp");
		/*
         var indexHtml= tinymce.activeEditor.dom.get("GenBtns") //初始化序号
         var count=indexHtml.children.length;
         index=count+1;
         
          tinymce.activeEditor.dom.add(editor.dom.get('GenDiv'), 'p', {id:'genName'+index,class: ''}, '<br>');
         //获取序号 index
         tinymce.activeEditor.dom.add(editor.dom.get('GenBtns'), 'div', {id:'minbtn'+index,class: 'minus'}, '<br>');    //添加减号箭头 shy 2022-09-09  
         
         //安排序号绑定事件
			    editor.dom.get('minbtn'+index).addEventListener('click', function () { 
			    debugger;
			   		 count=indexHtml.children.length;
        			 index=count
			         //删除该指定dom
			         tinymce.activeEditor.dom.remove(tinymce.activeEditor.dom.select('#minbtn'+index));
			         tinymce.activeEditor.dom.remove(tinymce.activeEditor.dom.select('#genName'+index));
			        },true)
			        */
        },true)
 //商品名新增
 	var ProIndex=0
	editor.dom.get('ProNamePropbtn').addEventListener('click', function () { 
		attrType="商品名";
		var ThisID=serverCall("web.DHCCKBCommon","GetProNameProp",{"MWToken":TOKEN})
		OpenWin(ThisID,"datagrid","ProNameProp");
	
        /* var indexHtml= tinymce.activeEditor.dom.get("ProNamePropBtns") //初始化序号
         var count=indexHtml.children.length;
         ProIndex=count+1;
         
          tinymce.activeEditor.dom.add(editor.dom.get('ProNamePropDiv'), 'p', {id:'ProNamePropName'+ProIndex,class: ''}, '<br>');
         //获取序号 index
         tinymce.activeEditor.dom.add(editor.dom.get('ProNamePropBtns'), 'div', {id:'Prominbtn'+ProIndex,class: 'minus'}, '<br>');    //添加减号箭头 shy 2022-09-09  
         
         //安排序号绑定事件
			    editor.dom.get('Prominbtn'+ProIndex).addEventListener('click', function () { 
			    debugger;
			   		 count=indexHtml.children.length;
        			 ProIndex=count
			         //删除该指定dom
			         tinymce.activeEditor.dom.remove(tinymce.activeEditor.dom.select('#Prominbtn'+ProIndex));
			         tinymce.activeEditor.dom.remove(tinymce.activeEditor.dom.select('#ProNamePropName'+ProIndex));
			        },true)*/
        },true)
	
  //成分新增
	editor.dom.get('IngredientBtn').addEventListener('click', function () { 
		debugger;
		attrType="成分";
		var ThisID=serverCall("web.DHCCKBCommon","GetDrugIngredient",{"MWToken":TOKEN})
		OpenWin(ThisID,"datagrid","Ingredient");
         
        },true)

 //等效单位新增
/*	editor.dom.get('EqUnitPropbtn').addEventListener('click', function () { 
		debugger;
		attrType="等效单位";
		var ThisID=serverCall("web.DHCCKBCommon","GetEqUnitProp")
		OpenWin(ThisID,"datagrid","EqUnitProp");
         
        },true)
       
      
 //药学分类
    editor.dom.get('DrugCategorybtn').addEventListener('click', function () { 
		debugger;
		attrType="药学分类";
		var ThisID=serverCall("web.DHCCKBCommon","GetPhCategory")
		OpenWin(ThisID,"tree","DrugCategory");
         
        },true)
  */               
}
                

//点击弹窗
function OpenWin(attrIDInput,htmlTypeInput,attrCodeInput)
{
	debugger;
	var attrID=attrIDInput;
	var htmlType=htmlTypeInput;
	var attrCode=attrCodeInput;
	var parref= getQueryVariable("ID")    //("parref");
	var $width="780";
	var $height="500";
	//$(".div-common").hide();
	$("#dsou").val("");		
	$("#myWin").show();
	$HUI.searchbox("#myChecktreeDesc").setValue("");
	$("input[name='FilterCK'][type='radio']").radio('setValue',false);
	/// 根据类型加载对应的数据	
	if (htmlType == "textarea"){			
		$("#linkID").val("");
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType+"&MWToken="+TOKEN;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
			
	}else if (htmlType == "tree"){
		$("#mydatagrid").hide();
		var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
		var options={}
		options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+attrID+"&input="+"&param="+param+"&MWToken="+TOKEN;
		$('#mygrid').tree(options);
		$('#mygrid').tree('reload');
		
	}else if(htmlType == "treegrid"){
	

	}else  if(htmlType == "datagrid"){
		$("#mytree").hide();
		InitAddgridDataList(attrCode,attrID,htmlType);		
		var options={}
		var params = parref +"^"+attrID;
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType+"&MWToken="+TOKEN;
		$('#addgrid').datagrid(options);
		$('#addgrid').datagrid('reload');
		
	}else if(htmlType == "checkbox"){
	
		
	}else{
		htmlType = "textarea";
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType+"&MWToken="+TOKEN;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
	}	
	
		/// 展示维护界面
		$("#my"+htmlType).show();
		
		 var ID=getQueryVariable("ID")
    	 var dicParref=getQueryVariable("dicParref")

         $("#myWin").show();
         //$HUI.dialog('#myWin').show();
		 /// 初始化已经维护的属性值
			InitEditValue(attrID,htmlType);
			
			var myWin = $HUI.dialog("#myWin",{
				//iconCls:'icon-write-order',
				//resizable:true,
				title:'添加',
				modal:true,
				width:$width,
				height:$height,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					iconCls:'icon-save',
					id:'save_btn',
					handler:function(){				
						SaveAttrValue();
					}
				},{
					text:'关闭',
					iconCls:'icon-close',
					handler:function(){
						myWin.close();
					}
				}]
			});
}

/// 初始化弹出窗已经维护的属性值
function InitEditValue(attrID,htmlType){
	var dicID =getQueryVariable("ID");

	runClassMethod("web.DHCCKBDicLinkAttr","GetAttrValueJson",{"dicID":dicID,"attrID":attrID,"htmlType":htmlType,"MWToken":TOKEN},function(jsonString){

		var obj=jsonString; //jQuery.parseJSON(jsonString);		
		if ($g(obj) != ""){
			
			if (htmlType == "textarea"){
				
				var rowsArr = $g(obj.rows);
				var result = "";
				var linkID = "";
				$.each(rowsArr,function(index,itmObj){
					
					result = result + $g(itmObj.result);
					linkID = $g(itmObj.linkID);		// 文本输入只有一条记录，如果有多条记录，修改时，保存到最后一条记录中
				})	
				$("#myarea").val(result);
				$("#linkID").val(linkID);
			}	
		}else{
			 $.messager.alert('提示','获取数据失败。'+jsonString,'warning');
		}					
	},"json",false)

}

/// 弹窗DataGrid初始定义
function InitAddgridDataList(attrCode,attrID,htmlType){
	var parref= getQueryVariable("ID");
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns	
	var columns=[];
	var Array=[],dgObj={};
	runClassMethod("web.DHCCKBDicLinkAttr","GetColumnsByDicCode",{"AttrId":"","DicCode":attrCode,"MWToken":TOKEN},function(jsonString){
		if(jsonString==""){ return;}
		var jsonObj=jsonString;
		for(var i=0;i<jsonObj.total;i++){
			dgObj={};
			dgObj.field=jsonObj.rows[i].Code;
			dgObj.title=jsonObj.rows[i].Desc;
			dgObj.align="center";
			dgObj.width=200;
			if((jsonObj.rows[i].Code.indexOf("Id")>=0)||(jsonObj.rows[i].Code=="dicGroupFlag"))
			{
				dgObj.hidden=true;
			} 
			if(jsonObj.rows[i].edtstr==""){ //默认格式
				dgObj.editor=textEditor;
			}else{		//维护的格式
				var tempeditor=jsonObj.rows[i].edtstr;		//后台格式串
				var tempObj={};								//编辑格式对象
				optionobj={};								//option 对象
				tempObj.type=tempeditor.split("@")[0];		//编辑格式
				optionobj.valueField=tempeditor.split("@")[1];
				optionobj.textField=tempeditor.split("@")[2];
				optionobj.editable=tempeditor.split("@")[3];
				optionobj.url=$URL+"?"+tempeditor.split("@")[5];
				optionobj.panelHeight=200;
				optionobj.mode="remote";
				tempObj.options=optionobj;
				dgObj.editor=tempObj;
			}
			Array.push(dgObj);
	 	}
		columns.push(Array);
		var option={	
			bordr:false,
			fit:true,
			fitColumns:true,
			singleSelect:true,	
			nowrap: false,
			striped: true, 
			pagination:true,
			rownumbers:true,
			pageSize:30,
			pageList:[30,60,90],		
	 		onClickRow:function(rowIndex,rowData){}, 	
	 		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	            var fileds=$('#addgrid').datagrid('getColumnFields');
				var params=fileds.join("&&");
				runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params,"MWToken":TOKEN},function(jsonString){
					
					for(var j=0;j<jsonString.length;j++)
					{
						if(jsonString[j].editors=="combobox"){
							var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
							e.editor = {
								type:'combobox',
							  	options:{
								valueField:'value',
								textField:'text',
								mode:'remote',
								url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed+"&MWToken="+TOKEN,
								onSelect:function(option) {
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
									$(ed.target).combobox('setValue', option.text);
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
									$(ed.target).val(option.value); 
								} 
							 }
						  }
						}	
					}
					if (subEditRow != ""||subEditRow == 0) { 
	                	$("#addgrid").datagrid('endEdit', subEditRow); 
	           		} 
		            $("#addgrid").datagrid('beginEdit', rowIndex); 
		            
		            subEditRow = rowIndex;
				})
	        }	
			  
		}
		var params = parref +"^"+ attrID	;
		var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType+"&MWToken="+TOKEN;

		new ListComponent('addgrid', columns, uniturl, option).Init();
			
	},'json','false')	
}


///新增数据源
function InsertDsourceO(flag)
{
	var datacode=""
	if(flag==1){
		datacode=$.trim($HUI.searchbox("#myChecktreeDesc").getValue());
	}else{
		datacode=$.trim($("#dsou").val());
	}
	
	var ListData="" +"^"+ datacode +"^"+ datacode +"^"+ EntLinkId;
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":ListData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else{
			 $.messager.alert('提示','保存失败，失败代码'+jsonString,'warning');
		}					
	})
}
/// 弹窗中新增
function AddBtn(){

	var fileds=$('#addgrid').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params,"MWToken":TOKEN},function(jsonString){
		
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
				e.editor = {
					type:'combobox',
				  	options:{
					valueField:'value',
					textField:'text',
					mode:'remote',
					url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed+"&MWToken="+TOKEN,
					onSelect:function(option) {
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
						$(ed.target).combobox('setValue', option.text);
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
						$(ed.target).val(option.value); 
					} 
				 }
			  }
			}	
		}
		
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);		//结束编辑，传入之前编辑的行
		}
		$("#addgrid").datagrid('insertRow', {
			index: 0, // 行数从0开始计算
			row: {}
		});
		
		$("#addgrid").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
		subEditRow=0;
	})
}


/// 弹窗中删除
function DelBtn()
{
	var rowsData = $("#addgrid").datagrid('getSelected'); //选中要删除的行
	var params = rowsData.Id;
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelData",{"params":params,"MWToken":TOKEN},function(jsonString){
					if (jsonString!="0")
					{
						$.messager.alert('提示','ErrorCode:'+jsonString,'warning');
					}
					$('#addgrid').datagrid('reload'); //重新加载
					location.reload(); 
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
/// 弹出窗保存属性值
function SaveAttrValue(){

	// 获取实例
	var tmpparref =getQueryVariable("ID");
	if(tmpparref == ""){
		 $.messager.alert('提示','请选择一个药品名称','warning');
		 return;
	}
	// 获取属性
	var attrID="";
	var htmlType="";
	var DicCode="";
	if(attrType=="")
	{
		 $.messager.alert('提示','请选择一个属性','warning');
		 return;	
	}
	//按属性类别赋值
	if(attrType=="成分")
	{
		attrID=serverCall("web.DHCCKBCommon","GetDrugIngredient",{"MWToken":TOKEN});
		htmlType="datagrid";
		DicCode="Ingredient";
	}
	if(attrType=="商品名")
	{
		attrID=serverCall("web.DHCCKBCommon","GetProNameProp",{"MWToken":TOKEN});
		htmlType="datagrid";
		DicCode="ProNameProp";
	}
	if(attrType=="通用名")
	{
		attrID=serverCall("web.DHCCKBCommon","GetGeneralFromData",{"MWToken":TOKEN});
		htmlType="datagrid";
		DicCode="GenerNameFormProp";
	}
	if(attrType=="等效单位")
	{
		attrID=serverCall("web.DHCCKBCommon","GetEqUnitProp",{"MWToken":TOKEN});
		htmlType="datagrid";
		DicCode="EqUnitProp";
	}
	if(attrType=="药学分类")
	{
		attrID=serverCall("web.DHCCKBCommon","GetPhCategory",{"MWToken":TOKEN});
		htmlType="tree";
		DicCode="DrugCategory";
	}
	if(attrID == 0){
		 $.messager.alert('提示','请选择一个属性','warning');
		 return;
	}
	
	var linkRowID=""	
	var linkAttrDr="";
	switch ($g(htmlType)) {
		
		case "textarea":
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('提示','请填写内容！','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;
			
		case "tree":	
			var attrArr=$('#mygrid').tree('getChecked');
			if(($g(attrArr.length) != 0)&&($g(attrArr.length) != "")){
				linkAttrDr = attrArr[0].id;
			}
			break;
		case "datagrid":
			linkRowID = $("#linkID").val();						//实例ID
			break;	
		default:
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('提示','请填写内容！','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;

	}
	
	SaveDataWithType(htmlType,attrID,tmpparref,DicCode);   	//调用保存函数  sufan 2019-11-18		

	return;
}
///根据不同类型来保存数据
function SaveDataWithType(htmlType,linkRowID,tmpparref,DicCode)
{
	var dataList=[];
	// 获取维护的属性值
	if (($g(htmlType) == "textarea")||($g(htmlType) == "")){			//保存textarea数据
		var selItem=$("#linklist").datagrid('getSelected');
		var AttrLink="";
		if(selItem){
			AttrLink=selItem.id;
		}
		linkAttrValue=$("#myarea").val();
		var params=AttrLink +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+linkAttrValue;
			
	}else if (htmlType == "tree"){	
		var attrArr=$('#mygrid').tree('getChecked');
		if(attrArr.length==0){
			var params= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+""+"^"+ "";
		}else{
			for (var i=0;i<attrArr.length;i++){
				var nodeId=attrArr[i].id;
				var node=$('#mygrid').tree('find',nodeId)
				var isLeaf = $("#dictree").tree('isLeaf',node.target);
				//if(!isLeaf){continue;}
				var tmp= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+ nodeId +"^"+ "";
				dataList.push(tmp);
				
			}
			var params=dataList.join("&&");
		}
	}else if ((htmlType == "datagridinput")||(htmlType == "input")){
			
	}else if(htmlType == "datagrid"){			//保存datagrid 
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);
		}
		var rowsData = $("#addgrid").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("提示","没有待保存数据!");
			return;
		}
		///取维护的列
		var fileds=$('#addgrid').datagrid('getColumnFields');
		var ListStr="0" +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+ ""
		dataList.push(ListStr);
		for(var i=0;i<rowsData.length;i++){
			var GroupNum=rowsData[i].dicGroupFlag;
			for (var j=1;j<fileds.length;j++){
				var ItmId=rowsData[i].Id==undefined?0:rowsData[i].Id
				var e = $("#addgrid").datagrid('getColumnOption',fileds[j]);
				//var dicDataType=serverCall("web.DHCCKBDicLinkAttr","GetAddAttrCode",{"queryCode":fileds[j],"queryDicID":"","AttrLinkCode":"DataTypeProp"})
				if(e.editor.type=="combobox"){continue;}		//下拉框数据不存储
			    if(fileds[j]=="dicGroupFlag"){continue;}	//组标识不存储
				var ListData = ItmId +"^"+ tmpparref +"^"+ linkRowID +"^"+ rowsData[i][fileds[j]] +"^"+ fileds[j] +"^"+ i +"^"+ GroupNum;
				dataList.push(ListData);
			}
			
		} 
		var params=dataList.join("&&");
	}else if(htmlType == "checkbox"){
			
	}else{
		
	}
	//保存数据
	saveTypeData(params,htmlType,1)
	
}
function saveTypeData(params,htmlType,flag)
{
	runClassMethod("web.DHCCKBDicLinkAttr","saveDicAttrByType",{"ListData":params,"Type":htmlType,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd,"MWToken":TOKEN},function(jsonString){
	
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！ErrCode'+jsonString,'warning');		
			return;	
		}else{
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
			if(flag==1){
				$HUI.dialog("#myWin").close();
			}
			location.reload(); 
			 
			//SubQueryDicList();   //保存后不刷新
			return;
		}		
	});
}

/// 弹窗属性值treeGrid初始定义
function InitAttrValueList(){
						
	var url = ""  //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		fitColumns:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:true,
        onClick:function(node, checked){
	      
	    },
	    onLoadSuccess: function(node, data){
			
			var AttrIdList=serverCall("web.DHCCKBDicLinkAttr","QueryEntyLinkAttr",{"EntyId":getQueryVariable("ID"),"AttrCode":"38","MWToken":TOKEN})
	        var AttrArray=AttrIdList.split(",");
	        for (var i=0;i<AttrArray.length;i++){
		         if($("#mygrid").tree('find',AttrArray[i])==null){continue;}
		         var n=$("#mygrid").tree('find',AttrArray[i])
		         $("#mygrid").tree('check',n.target);
		    } 
		}
	};
	new CusTreeUX("mygrid", url, option).Init();
}


///新增数据源
function InsertDsource(flag)
{
	var datacode="";
	var EntLinkId="";
	//按属性类别赋值

	//EntLinkId=tkServerCall("web.DHCCKBCommon","GetDicIdByDesc",{"desc":attrType});
	
	runClassMethod("web.DHCCKBCommon","GetDicIdByDesc",{"desc":attrType},function(jsonString){
		
		EntLinkId = jsonString;
		
	},'',false)
	
	if(flag==1){
		datacode=$.trim($HUI.searchbox("#myChecktreeDesc").getValue());
	}else{
		datacode=$.trim($("#dsou").val());
	}
	
	var ListData="" +"^"+ datacode +"^"+ datacode +"^"+ EntLinkId;
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":ListData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else{
			 $.messager.alert('提示','保存失败，失败代码'+jsonString,'warning');
		}					
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
