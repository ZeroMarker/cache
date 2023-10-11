/// 名称: 医用知识库 -列表型属性内容维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
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
	var urlArr=[]   //引用列表型控件的url信息

	
	if (extendChild!="")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) 
		{
			var fieldid=colsField[i];
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
						url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+baseid,
						onBeforeExpand:function(node){
							$(this).tree('expandFirstChildNodes',node)
				        }
					})	
				}
				else   //下拉框
				{
					urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid
					$('#'+comId).combobox({ 
						//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid,
						valueField:'MKBTRowId',
						textField:'MKBTDesc',
						delay:500,
						mode:'remote',
						comboFieldId:fieldid, //child
						onShowPanel:function(){
								var opts = $(this).combobox('options')
				         		if (opts)
				         		{
				         			$(this).combobox('setValue',"");
				         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
				         		}
				         	}
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
			else if(type=="SD")  //知识表达式
			{
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'F" name="'+comId+'F" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()

				var newRow='<tr style="display:none">'+ 
				   '<td class="tdlabel"></td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId+'F').validatebox()	
				
				CreatExpDom(comId,configInfos)				
			}
			else if (type=="D")  //日期
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input class="hisui-datebox textbox datebox-f combo-f" id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
	
				$('#'+comId).datebox({
					onShowPanel:function(){
			  			$(this).datebox('panel').click(stopPropagation)
			  		}	
				})			
			}
		}
	}
	
	//创建表达式控件
	function stopProp(e) { 
	　　if (e.stopPropagation) 
	　　　　e.stopPropagation(); 
	　　else 
	　　　　e.cancelBubble = true; 
	} 
	
	function CreatExpDom(jq2,baseId){
		var target=$('#'+jq2+'F')
		var targetf=$('#'+jq2)		
		target.click(function(e){
			stopProp(e); 
			detailstr[jq2]=targetf.val();
			//alert(detailstr[jq2])
			//console.log($(this))
			loadData(detailstr[jq2],baseId,jq2,$(this))
			if(target.offset().top+$("#knoExe").height()+35>$(window).height()){
				$("#knoExe").css({
					"top": target.offset().top-$("#knoExe").height()-25
				}).show();
			}
			else{
				$("#knoExe").css({
					"top": target.offset().top+30
				}).show();
			}
			if($(window).width()-target.offset().left<$("#knoExe").width()){
				$("#knoExe").css({
					"left": $(window).width()-$("#knoExe").width()
				}).show();

			}
			else{
				$("#knoExe").css({
					"left": target.offset().left
				}).show();
			}		

						
			$("#read_btn").click(function(){
				parent.document.getElementById("myWinProperty").style.display = 'none';
				addBase(baseId,jq2)	
				$("#knoExe").unbind('hide').hide("normal",function(){
					targetf.val(detailstr[jq2])
					var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',detailstr[jq2])
					target.val(detail)
				})
			})
			$(".knowledgeclass").next().find("input").focus();
		});		
		
	}
	//重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	//添加按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	//重置方法
	ClearFunLib=function()
	{
		//代码和描述赋值
		var textInfo=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",property);
		var info=textInfo.split("[A]");
		var id=info[0]  //全局变量 私有属性值表User.MKBTermProDetail的ID_"[A]"_属性内容		
		if(id!="")
		{
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBTermProDetail",
				MethodName:"NewOpenData",
				id:id,
				property:property
			},function(jsonData){

				if (extendChild!="")   //如果有单选框复选框，则给单选框复选框赋值
				{
					//给扩展属性赋值
					var colsField = extendChild.split("[N]"); 
					var typeStr = extendType.split("[N]"); 
					var configStr = extendConfig.split("[N]"); 
					for (var i = 0; i <colsField.length; i++) {
						var child=colsField[i]    //child
						var type=typeStr[i]   //格式
						var configInfos=configStr[i]  //配置项
						var comId='Extend'+colsField[i];   //控件id	
						
						if (type=="R")  //单选框 男&%女&%全部
						{
							var extendValue=jsonData[comId]
							var configs = configInfos.split("&%"); 
							for (var j = 0; j <configs.length; j++) 
							{
								if(configs[j]==extendValue)
								{
									$HUI.radio('#'+colsField[i]+'a'+j).setValue(true);
								}
								else
								{
									$HUI.radio('#'+colsField[i]+'a'+j).setValue(false);
								}
							}	
						}
						if (type=="CB")  //复选框 苹果&%香蕉&%梨
						{
							var extendValue=jsonData[comId]  //苹果,香蕉
							var configs = configInfos.split("&%"); 
							var CBValue=extendValue.split(","); 
							for (var j = 0; j <configs.length; j++) //遍历配置项 苹果&%香蕉&%梨
							{
								var CheckFlag=""  //选中标识
								for(var z=0;z<CBValue.length;z++)   //遍历扩展属性值 苹果&%梨
								{
									if(configs[j]==CBValue[z])  
									{
										CheckFlag="Y"
										break
									}
								}
								if (CheckFlag=="Y")  //选中
								{
									$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(true);
								}
								else
								{
									$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(false);
								}
							}					
						}
						if (type=="TA")
						{
							jsonData[comId]=jsonData[comId].replace(/<br\/>/g,"\n");    
						}
						if (type=="SD")
						{
							jsonData[comId+"F"]=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',jsonData[comId])
						}
						if (type=="S")
						{
				
							if ((urlArr[child]!="")&&(urlArr[child]!=undefined)){
								var url=urlArr[child]+"&rowid="+jsonData[comId]
								$('#'+comId).combobox('reload',url);
							}
						}
						
					}
				}
				//表单赋值
				$('#form-save').form("load",jsonData);			
			});	
		}
		else
		{

			if (extendChild!="")   //如果有单选框复选框，则给单选框复选框赋值
			{
				//给扩展属性赋值
				var colsField = extendChild.split("[N]"); 
				var typeStr = extendType.split("[N]"); 
				var configStr = extendConfig.split("[N]"); 
				for (var i = 0; i <colsField.length; i++) {
					var child=colsField[i]    //child
					var type=typeStr[i]   //格式
					var configInfos=configStr[i]  //配置项
					
					if (type=="R")  //单选框 男&%女&%全部
					{
						var configs = configInfos.split("&%"); 
						for (var j = 0; j <configs.length; j++) 
						{
							$HUI.radio('#'+colsField[i]+'a'+j).setValue(false);							
						}	
					}
					if (type=="CB")  //复选框 苹果&%香蕉&%梨
					{
						var configs = configInfos.split("&%"); 
						for (var j = 0; j <configs.length; j++) //遍历配置项 苹果&%香蕉&%梨
						{	
							//alert(colsField[i]+'a'+j)
							$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(false);	
						}					
					}
					
				}
			}
			//清空表单
			$('#form-save').form('clear');

		}


	}
	ClearFunLib();



	///新增、更新
	SaveFunLib=function()
	{		
		if ($.trim($("#MKBTPDDesc").val())=="")
		{
			$.messager.alert('错误提示','中心词不能为空!',"error");
			return;
		}
	
		var extendValue=""
		if (extendChild!="")   //如果有扩展属性
		{
			var colsField = extendChild.split("[N]"); 
			var typeStr = extendType.split("[N]"); 
			var configStr = extendConfig.split("[N]"); 
			for (var i = 0; i <colsField.length; i++) 
			{
				var id="#Extend"+colsField[i]
				var type=typeStr[i]
				var child=colsField[i]
				var extProValue=""			
				if (type=="TX")
				{
					extProValue=$.trim($(id).val())
				}
				else if (type=="TA")
				{
					extProValue=$.trim($(id).val())
				}
				else if(type=="S")  //引用
				{
					var configInfos=configStr[i]
					if (configInfos!="")
					{
						var baseInfo = configInfos.split("&%"); 
						var baseid=baseInfo[0]   //术语库注册id
						var baseType=baseInfo[1]   //术语库类型
						if (baseType=="T")  //下拉树			
						{
							extProValue=$(id).combotree('getValue')
						}
						else  //下拉框
						{
							extProValue=$(id).combobox('getValue')
						}
					}
				}
				else if(type=="C")  //下拉框
				{
					extProValue=$(id).combobox('getValue')
				}
				else if(type=="R")  //单选框
				{
					var radioName="Extend"+colsField[i]
					// 获得选中的值
					var checkedRadioJObj = $("input[name='"+radioName+"']:checked");
					extProValue=checkedRadioJObj.val()
				}
				else if(type=="CB")  //复选框
				{
					var comboboxName="Extend"+colsField[i]
					// 获得选中的值
					var checkBoxArr = [];  
					$("input[name='"+comboboxName+"']:checked").each(function() {  
						checkBoxArr.push($(this).val());  
					});  
					extProValue=checkBoxArr.join('&%');  //数组按指定格式拼串
				}
				else if(type=="SD")
				{
					if($(id+"F").val()!="")
					{
						extProValue=$.trim($(id).val())
					}
				}
				else if(type=="D")
				{						
					extProValue=$(id).datebox('getValue');
				}
				
				if ((extProValue=="undefined")||(extProValue==null)){extProValue=""}
				if (extendValue!="")
				{
					var extendValue=extendValue+"[N]"+child+"[A]"+extProValue
				}
				else
				{
					var extendValue=child+"[A]"+extProValue
				}	
			}
		}
		//alert(extendValue)
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTPDRowId = $("#MKBTPDRowId").val(),
				param.MKBTPDProDR=property,
				param.MKBTPDExtend=extendValue
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '保存成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						});*/
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					$("#MKBTPDRowId").val(data.id)						

				  } 
				  else { 
						var errorMsg ="保存失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
		
				}

			} 
		});



	}

	///删除
	DelData=function()
	{        
		var id=$("#MKBTPDRowId").val()
		if (id=="") return 
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":id     ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									/*$.messager.show({ 
									  title: '提示消息', 
									  msg: '删除成功', 
									  showType: 'show', 
									  timeout: 1000, 
									  style: { 
										right: '', 
										bottom: ''
									  } 
									});*/
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									ClearFunLib();
							  } 
							  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
	
};
$(init);
