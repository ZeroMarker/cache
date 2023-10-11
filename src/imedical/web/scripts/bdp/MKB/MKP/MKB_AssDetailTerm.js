/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-石萧伟
/// 编写日期: 2018-04-04
var  property=property
var  propertyName=propertyName
var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForCmb"
	//var property=1
	var activeIndex="";   //正在编辑行的行号
	//var activeId=""     //正在编辑行的id
	var proConfigInfos = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProConfigInfo",property)  //配置项信息
	var proConfigInfo=proConfigInfos.split("^")  
	var configBaseId = proConfigInfo[0];   //术语库注册id
	var configBaseType = proConfigInfo[1];  //术语库注册类型L/T
	
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
					{field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTDesc',title:'描述',width:150,sortable:true},
					{field:'MKBTCode',title:'代码',width:150,sortable:true}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelTermList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:true,
		idField:'MKBTRowId',
		fitColumns:true,  
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true	
		scrollbarSize :0,
		onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

        }		  
	});	
}
$(init);
