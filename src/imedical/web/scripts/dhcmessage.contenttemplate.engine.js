/*
* 消息内容模板模块 提供给其它界面调用的JS方法
* content_saveAs_template(content)  //弹出分类选择窗口 选择后保存  另外可以用户点击新增分类
*/
;(function(root){
	var $g=root.$g
	if($g=='undefined'){
		$g=function(a){return a;}	
	}
	var getTokenUrl=function(url){
		
		if(typeof url=='string' && url.indexOf('.csp')>-1) {
			var token='';
			if(typeof websys_getMWToken=='function' ){
				token= websys_getMWToken();
			}
			
			var arr=url.split('#');
			arr[0]=arr[0]+(arr[0].indexOf('?')>-1?'&':'?')+'MWToken='+token; 
			url=arr.join('#');
		}
		return url;
	}
	if($.messager && !$.messager.popover) {
		
		$.messager.popover=function(obj){
			var icon=obj.type;
			if(icon=='alert') icon='error';
			
			$.messager.alert('提示',obj.msg, icon )
		}
	}
	
	var CURR_DATA={};
	var typeDescMap={T:'模板','TC':'模板分类','D':'草稿','DC':'草稿分类'}
	
	
	//另存为
	var content_saveAs=function(type,content){
		CURR_DATA={type:type,content:content,typeDesc:typeDescMap[type]};
		
		if(!content) {
			$.messager.popover({msg:'内容为空',type:'alert'});
			return;
		}
		
		if( !$.fn.keywords ) {  //没有关键字  打开页面的方式
			
			if($('#content-tmpl-cat-sel-win').length==0) {
				$('<div id="content-tmpl-cat-sel-win" style="overflow:hidden;"><iframe id="content-tmpl-cat-sel-frame" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');	
				
				$('#content-tmpl-cat-sel-win').dialog({
						width:600,
						height:500,
						modal:true,
						title:'请选择分类',
						iconCls:'icon-w-paper'
				})
						
				
			}
			$('#content-tmpl-cat-sel-win').dialog('open');
			
			root._content_tmpl_CURR_DATA=CURR_DATA;
			root._content_tmpl_close=function(op){
				if(op=='success'){  //成功保存
					
					$('#content-tmpl-cat-sel-win').dialog('close');
					
					
				}else{  //默认为关闭
					
					$('#content-tmpl-cat-sel-win').dialog('close');
				}
			}
			$('#content-tmpl-cat-sel-frame').attr('src',getTokenUrl('dhcmessage.contenttemplate.engine.csp'))
			
		
			return;
			
		}
		
		
		
		$.q({ClassName:'CT.BSP.MSG.BL.ContentTemplate',QueryName:'LookUp',type:type+'C',rows:9999},function(ret){
			if(ret && ret.rows instanceof Array){
				var temp={};
				$.each(ret.rows,function(){
					var item={text:this.TTitle,id:'content-tmpl-cat-'+this.TId}
					if(!temp[this.TRefType]) {
						temp[this.TRefType]={text:this.TRefTypeDesc,type:"section",items:[]}
					}
					temp[this.TRefType].items.push(item);
				})
				var kwdata=[];
				$.each(['U','L','G','H','S'],function(){
					if(temp[this]){
						kwdata.push( temp[this] )
					}
				})
				
				if($('#content-tmpl-cat-sel-win').length==0) {
					
					$('<div id="content-tmpl-cat-sel-win" style="padding:10px 10px 0 10px;"><div id="content-tmpl-cat-sel-wrap"></div></div>').appendTo('body');
					
					$('#content-tmpl-cat-sel-win').dialog({
						width:600,
						height:500,
						modal:true,
						title:'请选择分类',
						iconCls:'icon-w-paper',
						buttons:[{
							text:'新增分类',
							handler:function(){
								
								if($('#content-tmpl-cat-add-win').length==0) {
									$('<div id="content-tmpl-cat-add-win" style="padding:5px 10px 0 10px;"><table cellspacing="0" cellpadding="0"> \
										<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span>'+$g('保存类型')+'</td><td ><input class="textbox" style="width:200px;" id="content-tmpl-cat-add-reftype" type="text"/></td></tr> \
										<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span>'+$g('分类名称')+'</td><td ><input class="textbox" style="width:193px;" id="content-tmpl-cat-add-title" type="text"/></td></tr> \
										<tr style="height:60px;"><td style="text-align:right;padding-right:10px;">'+$g('分类备注')+'</td><td ><textarea style="height:50px;line-height:25px;overflow-y:auto;width:193px;" class="textbox" id="content-tmpl-cat-add-summary" ></textarea></td></tr> \
										 </table></div>').appendTo('body');
									$('#content-tmpl-cat-add-win').dialog({
										title:'新增分类',
										iconCls:'icon-w-paper',
										modal:true,
										width:300,
										buttons:[{
											text:'确定',
											handler:function(){
												var title=$('#content-tmpl-cat-add-title').val();
												var reftype=$('#content-tmpl-cat-add-reftype').combobox('getValue');
												var summary=$('#content-tmpl-cat-add-summary').val();
												if(!reftype){
													$.messager.popover({msg:'请选择保存类型',type:'alert'});
													return;
												}
												if($.trim(title)==''){
													$.messager.popover({msg:'请输入名称',type:'alert'});
													return;
												}
												var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
												data.Title=title;
												data.Summary=summary;
												data.MethodName='AddCatgory'	
												data.RefType=reftype;
												data.RefObjId='';
												data.Type=CURR_DATA.type+'C';
												$.m(data,function(rtn){
													if (rtn>0){
														$.messager.alert("成功","保存成功",'success',function(){
															$('#content-tmpl-cat-add-win').dialog('close');
															$('#content-tmpl-cat-sel-win').dialog('close');
															content_saveAs(CURR_DATA.type,CURR_DATA.content);  //重新打开此窗口
															
														});
													}else{
														$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
														
													}
												})
												
											}
										},{
											text:'取消',
											handler:function(){
												$('#content-tmpl-cat-add-win').dialog('close');
											}
												
										}]
									})
									
									$('#content-tmpl-cat-add-reftype').combobox({
										data:[{value:'U',text:$g('个人')},{value:'L',text:$g('科室')},{value:'G',text:$g('安全组')},{value:'H',text:$g('医院')},{value:'S',text:$g('站点')}]
										,value:'U'	,panelHeight:'auto',width:200
										
									})
								}
								$('#content-tmpl-cat-add-win').dialog('open');
								$('#content-tmpl-cat-add-reftype').combobox('setValue','U');
								$('#content-tmpl-cat-add-title,#content-tmpl-cat-add-summary').val('');
								
								
								
								
								
							}
								
						},{
							text:'确定',
							handler:function(){
								var sel=$('#content-tmpl-cat-sel-kw').keywords('getSelected');
								if(sel && sel.length>0) {
									var selItem=sel[0];
									var cat=selItem.id.split('-').pop();
									var catDesc=selItem.text;
									CURR_DATA.cat=cat;
									if($('#content-tmpl-tmpl-add-win').length==0) {
											$('<div id="content-tmpl-tmpl-add-win" style="padding:5px 10px 0 10px;"><table cellspacing="0" cellpadding="0"> \
												<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span class="content-tmpl-tmpl-add-type"></span>'+$g('分类')+'</td><td ><input class="textbox" style="width:193px;" disabled="true" id="content-tmpl-tmpl-add-cat" type="text"/></td></tr> \
												<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span><span class="content-tmpl-tmpl-add-type"></span>'+$g('名称')+'</td><td ><input class="textbox" style="width:193px;" id="content-tmpl-tmpl-add-title" type="text"/></td></tr> \
												<tr style="height:60px;"><td style="text-align:right;padding-right:10px;">'+$g('备注')+'</td><td ><textarea style="height:50px;line-height:25px;overflow-y:auto;width:193px;" class="textbox" id="content-tmpl-tmpl-add-summary" ></textarea></td></tr> \
												 </table></div>').appendTo('body');
											$('#content-tmpl-tmpl-add-win').dialog({
												title:'内容另存为',
												iconCls:'icon-w-paper',
												modal:true,
												width:300,
												buttons:[{
													text:'确定',
													handler:function(){
														var title=$('#content-tmpl-tmpl-add-title').val();
														var summary=$('#content-tmpl-tmpl-add-summary').val();
														if($.trim(title)==''){
															$.messager.popover({msg:'请输入名称',type:'alert'});
															return;
														}
														var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate",_headers:{'X-Accept-Tag':1}};
														data.Title=title;
														data.Summary=summary;
														data.MethodName='AddContent'	
														data.RefType='';
														data.RefObjId='';
														data.Catgory=CURR_DATA.cat;
														data.Type=CURR_DATA.type;
														data.Content=CURR_DATA.content;
														
														$.m(data,function(rtn){
															if (rtn>0){
																$.messager.alert("成功","保存成功",'success',function(){
																	$('#content-tmpl-tmpl-add-win').dialog('close');
																	$('#content-tmpl-cat-sel-win').dialog('close');
																});
															}else{
																$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
																
															}
														})
														
													}
												},{
													text:'取消',
													handler:function(){
														$('#content-tmpl-tmpl-add-win').dialog('close');
													}
														
												}]
											})
										}
										$('#content-tmpl-tmpl-add-win').dialog('open');
										$('#content-tmpl-tmpl-add-title,#content-tmpl-tmpl-add-summary').val('');
										$('.content-tmpl-tmpl-add-type').text($g(CURR_DATA.typeDesc));
										$('#content-tmpl-tmpl-add-cat').val(catDesc);
									
									
									
								}else{
									$.messager.popover({msg:'请选择分类',type:'alert'});
								}
							}
								
						},{
							text:'取消',
							handler:function(){
								$('#content-tmpl-cat-sel-win').dialog('close');
							}
								
						}]	
					})
					
				}
				$('#content-tmpl-cat-sel-win').dialog('open')
				
				$('#content-tmpl-cat-sel-wrap').empty().append('<div id="content-tmpl-cat-sel-kw"></div>');
				$('#content-tmpl-cat-sel-kw').keywords({
	                items:kwdata,
	                singleSelect:true
				})
				
				
				
				
			}else{
				$.messager.popover({msg:'获取分类数据失败',type:'alert'});
				
			}
			
		})
	}
	
	
	var initContentSelector=function(id,type,onSelect){
		var $URL=root.$URL||'websys.Broker.cls'
		var typeDesc=typeDescMap[type];
		$('#'+id).combogrid({
			width:180,
			panelWidth:450,
			delay: 500,
			mode: 'remote',
			url:$URL,
			queryParams:{
				ClassName:'CT.BSP.MSG.BL.ContentTemplate',QueryName:'LookUp',type:type,title:''
			},
			onBeforeLoad:function(param){
				param.title=param.q;
				return true;
			},
			onSelect:function(ind,row){
				
				$.m({ClassName:'CT.BSP.MSG.BL.ContentTemplate',MethodName:'OutputContent',Id:row.TId},function(ret){
						
					if(typeof onSelect=='function'){
						onSelect(ret);	
					}
				})
			},
			idField:"TId",textField:"TTitle",
			columns:[[
				{field:'TTitle',title:typeDesc+'名称',width:200},{field:'TCatgoryDesc',title:'类型与分类',width:200,formatter:function(val,row){
					return '【'+row.TRefTypeDesc+'】'+row.TCatgoryDesc;
				}}
			]],
			pagination:true
			
		})	
		
	}
	
	
	
	///另存为模板
	root.content_saveAs_template=function(content){
		content_saveAs('T',content);
	}
	
	///另存为草稿
	root.content_saveAs_draft=function(content){
		content_saveAs('D',content);
	}
	
	// 初始化模板选择框
	root.initTemplateSelector=function(id,onSelect){
		initContentSelector(id,'T',onSelect);	
	}
	// 初始化草稿选择框
	root.initDraftSelector=function(id,onSelect){
		initContentSelector(id,'D',onSelect);	
	}
	
})(window);
