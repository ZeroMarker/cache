/// 名称: 医用知识库 -列表型属性内容维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-石萧伟
/// 编写日期: 2018-04-04
var property=property
var propertyName=propertyName
var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
	//var property=1
var activeIndex="";   //正在编辑行的行号
	//var activeId=""     //正在编辑行的id
	
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串
	
	//缺省展示效果的id,用于缺省展示效果文本框内容的自动生成
	var emptycomid=""

	if (extendChild!="")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) {

			var labelName=colsHead[i];  //标题
			var comId='Extend'+colsField[i];   //控件id			
			var type=typeStr[i]   //类型
			var configInfos=configStr[i]  //配置项
			if (labelName=="缺省展示效果")
			{
				emptycomid=comId
			}
			if (type=="TX")  //文本框
			{
				var newRow='<tr>'+
				   '<td align="right">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()
			}
			else if(type=="TA")  //多行文本框
			{
				var newRow='<tr>'+
				   '<td align="right">'+labelName+'</td>'+
				   '<td><textarea id="'+comId+'" name="'+comId+'" type="text" style="height:100px;width:300px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()		
			}
			else if(type=="S")  //引用  注意：要换成MKBTerm，同时还要判断是列表下拉框还是树形下拉框
			{			
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td align="right">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
				var baseInfo = configInfos.split("&%"); 
				var baseid=baseInfo[0]   //术语库注册id
				var baseType=baseInfo[1]   //术语库类型
				if (baseType=="T")  //下拉树			
				{
					$('#'+comId).combotree({ 
						url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+baseid
					})	
				}
				else   //下拉框
				{
					$('#'+comId).combobox({ 
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetDataForCmb1&ResultSetType=array&base="+baseid,
						valueField:'MKBTRowId',
						textField:'MKBTDesc'
					})		
				}				
			}
			else if (type=="C")  //下拉框
			{
				var newRow='<tr>'+
				   '<td align="right">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
				//alert(configInfos)				
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["value"]=configs[j];  
					data["text"]=configs[j];  
					storeData.push(data)	
				}
				
				$('#'+comId).combobox({
					valueField:'value',
					textField:'text',
					data:storeData
				})			
			}
			else if (type=="R")  //单选框
			{
				//alert(configInfos)	
				var newRow='<tr><td align="right">'+labelName+'</td><td>'
				var str=""				
				var configs = configInfos.split("&%"); 				
				for (var j = 0; j <configs.length; j++) 
				{
					str=str+'<input type="radio" label="'+configs[j]+'" name="Extend'+colsField[i]+'" value="'+configs[j]+'" id="'+colsField[i]+'a'+j+'">'
				}
				newRow=newRow+str+	'</td></tr>'
				//alert(newRow)
				$('#form-save table').append(newRow);
				for (var j = 0; j <configs.length; j++) 
				{
					$('#'+colsField[i]+'a'+j).radio({
					})	
				}	

				
			}
			else if (type=="CB")
			{
				var newRow='<tr><td align="right">'+labelName+'</td><td>'
				var str=""				
				var configs = configInfos.split("&%"); 				
				for (var j = 0; j <configs.length; j++) 
				{
					str=str+'<input type="checkbox" label="'+configs[j]+'" name="Extend'+colsField[i]+'" value="'+configs[j]+'" id="'+colsField[i]+'a'+j+'">'
				}
				newRow=newRow+str+	'</td></tr>'
				//alert(newRow)
				$('#form-save table').append(newRow);
				for (var j = 0; j <configs.length; j++) 
				{
					$('#'+colsField[i]+'a'+j).checkbox({
					})	
				}				
			}
		}
	}
	
	//datagrid列
	var columns =[[   
					{field:'MKBTPRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTPDesc',title:'属性',width:150,sortable:true},
					{field:'MKBTPType',title:'格式',width:150,sortable:true,hidden:true},
					{field:'MKBTPShowType',title:'展示格式',width:150,sortable:true,
						formatter:function(v,row,index){  
							if(v=="C"){return "下拉框"}
							if(v=="T"){return "下拉树"}
							if(v=="TX"){return "文本框"}
							if(v=="TA"){return "多行文本框"}
							if(v=="CB"){return "单选框"}
							if(v=="CG"){return "复选框"}
							if(v=="MC"){return "多选下拉框"}							
						},
						editor : {
						    type: 'combobox',
							options: {
								data:[
										{value:'C',text:'下拉框'},
										{value:'T',text:'下拉树'},
										{value:'TX',text:'文本框'},
										{value:'TA',text:'多行文本框'},	
										{value:'CB',text:'单选框'},	
										{value:'CG',text:'复选框'},	
										{value:'MC',text:'多选下拉框'}
								],
								valueField: 'value',
								textField: 'text',
								editable:false,
								onShowPanel : function () {
									var ed=$("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPShowType"});
									var rows = $('#mygrid').datagrid('getRows');//获得所有行
									var row = rows[activeIndex];//根据index获得其中一行。
									var activeType=row.MKBTPType	
									var activeId=row.MKBTPRowId
									data=GetShowTypeData(activeType,activeId)
									$(ed.target).combobox('loadData',data);

								}	
								
							}
						}
					},
					{field:'MKBTPTreeNode',title:'定义节点',width:150,sortable:true,
						formatter:function(v,row,index){  
							var showvalue=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",v)
							//alert(v+"^"+showvalue)
							return showvalue						
						},
						editor : {
						    type: 'combotree',
							options: {
								//url:TREE_COMBO_URL,
								valueField: 'id',
								textField: 'text',
								panelHeight : 'auto',
								onShowPanel : function () {
									var ed =  $("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPTreeNode"});									
									var rows = $('#mygrid').datagrid('getRows');//获得所有行
									var row = rows[activeIndex];//根据index获得其中一行。
									var activeType=row.MKBTPType
									var activeId=row.MKBTPRowId
									if (activeType=="T")  //树形的才可以定义节点
									{
										var url=TREE_COMBO_URL+"&property="+activeId
										$(ed.target).combotree('reload',url);
									}

								}								
							}
							
						}
					}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelPropertyList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:true,
		idField:'MKBTPRowId', 
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,
		fitColumns:true,   //定义是否从服务器排序数据。true
		scrollbarSize :0,
		onClickCell:function(index, field, value){
			if(activeIndex!==""){
			   $(this).datagrid('endEdit', activeIndex);
			}
			$(this).datagrid('beginEdit', index);
			$(this).datagrid('selectRow', index);
			activeIndex=index;		
		},
		onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

        }
	});	
}
$(init);
