/// 名称: 医用知识库 -列表型属性内容维护
/// 编写者: 基础数据平台组-石萧伟
/// 编写日期: 2018-03-30

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
	//var property=1
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串


	
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
			if (type=="TX")  //文本框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()
			}
			else if(type=="TA")  //多行文本框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><textarea id="'+comId+'" name="'+comId+'" type="text" style="height:100px;width:480px;"></textarea></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()		
			}
			else if(type=="S")  //引用  注意：要换成MKBTerm，同时还要判断是列表下拉框还是树形下拉框
			{			
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
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
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid,
						valueField:'MKBTRowId',
						textField:'MKBTDesc',
						mode:'remote'
					})		
				}				
			}
			else if (type=="C")  //下拉框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
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
				var newRow='<tr><td class="tdlabel">'+labelName+'</td><td>'
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
				var newRow='<tr><td class="tdlabel">'+labelName+'</td><td>'
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
};
$(init);
