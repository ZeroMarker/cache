/*
* ��Ϣ����ģ��ģ�� �ṩ������������õ�JS����
* content_saveAs_template(content)  //��������ѡ�񴰿� ѡ��󱣴�  ��������û������������
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
			
			$.messager.alert('��ʾ',obj.msg, icon )
		}
	}
	
	var CURR_DATA={};
	var typeDescMap={T:'ģ��','TC':'ģ�����','D':'�ݸ�','DC':'�ݸ����'}
	
	
	//���Ϊ
	var content_saveAs=function(type,content){
		CURR_DATA={type:type,content:content,typeDesc:typeDescMap[type]};
		
		if(!content) {
			$.messager.popover({msg:'����Ϊ��',type:'alert'});
			return;
		}
		
		if( !$.fn.keywords ) {  //û�йؼ���  ��ҳ��ķ�ʽ
			
			if($('#content-tmpl-cat-sel-win').length==0) {
				$('<div id="content-tmpl-cat-sel-win" style="overflow:hidden;"><iframe id="content-tmpl-cat-sel-frame" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');	
				
				$('#content-tmpl-cat-sel-win').dialog({
						width:600,
						height:500,
						modal:true,
						title:'��ѡ�����',
						iconCls:'icon-w-paper'
				})
						
				
			}
			$('#content-tmpl-cat-sel-win').dialog('open');
			
			root._content_tmpl_CURR_DATA=CURR_DATA;
			root._content_tmpl_close=function(op){
				if(op=='success'){  //�ɹ�����
					
					$('#content-tmpl-cat-sel-win').dialog('close');
					
					
				}else{  //Ĭ��Ϊ�ر�
					
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
						title:'��ѡ�����',
						iconCls:'icon-w-paper',
						buttons:[{
							text:'��������',
							handler:function(){
								
								if($('#content-tmpl-cat-add-win').length==0) {
									$('<div id="content-tmpl-cat-add-win" style="padding:5px 10px 0 10px;"><table cellspacing="0" cellpadding="0"> \
										<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span>'+$g('��������')+'</td><td ><input class="textbox" style="width:200px;" id="content-tmpl-cat-add-reftype" type="text"/></td></tr> \
										<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span>'+$g('��������')+'</td><td ><input class="textbox" style="width:193px;" id="content-tmpl-cat-add-title" type="text"/></td></tr> \
										<tr style="height:60px;"><td style="text-align:right;padding-right:10px;">'+$g('���౸ע')+'</td><td ><textarea style="height:50px;line-height:25px;overflow-y:auto;width:193px;" class="textbox" id="content-tmpl-cat-add-summary" ></textarea></td></tr> \
										 </table></div>').appendTo('body');
									$('#content-tmpl-cat-add-win').dialog({
										title:'��������',
										iconCls:'icon-w-paper',
										modal:true,
										width:300,
										buttons:[{
											text:'ȷ��',
											handler:function(){
												var title=$('#content-tmpl-cat-add-title').val();
												var reftype=$('#content-tmpl-cat-add-reftype').combobox('getValue');
												var summary=$('#content-tmpl-cat-add-summary').val();
												if(!reftype){
													$.messager.popover({msg:'��ѡ�񱣴�����',type:'alert'});
													return;
												}
												if($.trim(title)==''){
													$.messager.popover({msg:'����������',type:'alert'});
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
														$.messager.alert("�ɹ�","����ɹ�",'success',function(){
															$('#content-tmpl-cat-add-win').dialog('close');
															$('#content-tmpl-cat-sel-win').dialog('close');
															content_saveAs(CURR_DATA.type,CURR_DATA.content);  //���´򿪴˴���
															
														});
													}else{
														$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
														
													}
												})
												
											}
										},{
											text:'ȡ��',
											handler:function(){
												$('#content-tmpl-cat-add-win').dialog('close');
											}
												
										}]
									})
									
									$('#content-tmpl-cat-add-reftype').combobox({
										data:[{value:'U',text:$g('����')},{value:'L',text:$g('����')},{value:'G',text:$g('��ȫ��')},{value:'H',text:$g('ҽԺ')},{value:'S',text:$g('վ��')}]
										,value:'U'	,panelHeight:'auto',width:200
										
									})
								}
								$('#content-tmpl-cat-add-win').dialog('open');
								$('#content-tmpl-cat-add-reftype').combobox('setValue','U');
								$('#content-tmpl-cat-add-title,#content-tmpl-cat-add-summary').val('');
								
								
								
								
								
							}
								
						},{
							text:'ȷ��',
							handler:function(){
								var sel=$('#content-tmpl-cat-sel-kw').keywords('getSelected');
								if(sel && sel.length>0) {
									var selItem=sel[0];
									var cat=selItem.id.split('-').pop();
									var catDesc=selItem.text;
									CURR_DATA.cat=cat;
									if($('#content-tmpl-tmpl-add-win').length==0) {
											$('<div id="content-tmpl-tmpl-add-win" style="padding:5px 10px 0 10px;"><table cellspacing="0" cellpadding="0"> \
												<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span class="content-tmpl-tmpl-add-type"></span>'+$g('����')+'</td><td ><input class="textbox" style="width:193px;" disabled="true" id="content-tmpl-tmpl-add-cat" type="text"/></td></tr> \
												<tr style="height:40px;"><td style="text-align:right;padding-right:10px;"><span style="color:red;">*</span><span class="content-tmpl-tmpl-add-type"></span>'+$g('����')+'</td><td ><input class="textbox" style="width:193px;" id="content-tmpl-tmpl-add-title" type="text"/></td></tr> \
												<tr style="height:60px;"><td style="text-align:right;padding-right:10px;">'+$g('��ע')+'</td><td ><textarea style="height:50px;line-height:25px;overflow-y:auto;width:193px;" class="textbox" id="content-tmpl-tmpl-add-summary" ></textarea></td></tr> \
												 </table></div>').appendTo('body');
											$('#content-tmpl-tmpl-add-win').dialog({
												title:'�������Ϊ',
												iconCls:'icon-w-paper',
												modal:true,
												width:300,
												buttons:[{
													text:'ȷ��',
													handler:function(){
														var title=$('#content-tmpl-tmpl-add-title').val();
														var summary=$('#content-tmpl-tmpl-add-summary').val();
														if($.trim(title)==''){
															$.messager.popover({msg:'����������',type:'alert'});
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
																$.messager.alert("�ɹ�","����ɹ�",'success',function(){
																	$('#content-tmpl-tmpl-add-win').dialog('close');
																	$('#content-tmpl-cat-sel-win').dialog('close');
																});
															}else{
																$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
																
															}
														})
														
													}
												},{
													text:'ȡ��',
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
									$.messager.popover({msg:'��ѡ�����',type:'alert'});
								}
							}
								
						},{
							text:'ȡ��',
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
				$.messager.popover({msg:'��ȡ��������ʧ��',type:'alert'});
				
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
				{field:'TTitle',title:typeDesc+'����',width:200},{field:'TCatgoryDesc',title:'���������',width:200,formatter:function(val,row){
					return '��'+row.TRefTypeDesc+'��'+row.TCatgoryDesc;
				}}
			]],
			pagination:true
			
		})	
		
	}
	
	
	
	///���Ϊģ��
	root.content_saveAs_template=function(content){
		content_saveAs('T',content);
	}
	
	///���Ϊ�ݸ�
	root.content_saveAs_draft=function(content){
		content_saveAs('D',content);
	}
	
	// ��ʼ��ģ��ѡ���
	root.initTemplateSelector=function(id,onSelect){
		initContentSelector(id,'T',onSelect);	
	}
	// ��ʼ���ݸ�ѡ���
	root.initDraftSelector=function(id,onSelect){
		initContentSelector(id,'D',onSelect);	
	}
	
})(window);
