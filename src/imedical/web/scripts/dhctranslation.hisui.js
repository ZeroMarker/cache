var unInitArr = [true,true,true,true,true,true];
var curGridId ="";
var defaultCallBack = function(rtn){
	if (rtn>0){
		$("#"+curGridId).datagrid("acceptChanges");
		$.messager.popover({msg:$g("����ɹ�"),type:'success'});
	}else{
		$.messager.popover({msg:$g("����ʧ��."+rtn),type:'error'});
	}
}
function replaceSpace(str){
	var reg=new RegExp(" ","g");
	str = str.replace(reg,"&nbsp;");
	str = str.replace(String.fromCharCode(1),"&nbsp;");
	return str;
}
var formatTitle=function(phrase,translation){
	var title='����<span style="color:red;" title="'+phrase+'">'+replaceSpace(phrase.substring(0,15))+""+(phrase.length>15 ? "..." :"")+'</span>���ķ��롾<span style="color:red;" title="'+translation+'">'+replaceSpace(translation.substring(0,15))+""+(translation.length>15 ? "..." :"")+'</span>��Ӧ�õ�&nbsp;&nbsp';
	return title;
}
var delDefaultCallBack = function(rtn){
	if (rtn==1){
		var grid = $('#'+curGridId);
		var row = grid.datagrid('getSelected');
		var currEditIndex = grid.datagrid('getRowIndex',row);
		grid.datagrid('deleteRow',currEditIndex);
	}else{
		$.messager.popover({msg:$g("ɾ��ʧ��."+rtn),type:'error'});
	}
}
function tabSelect(title,index){
	if (unInitArr[index]) window["initTab"+index].call();
	return;
}
var ToCompBtnClick=function(rowIndex,phrase,translation){
	if (translation==""){$.messager.popover({msg:$g("�շ��벻��Ӧ��"),type:'alert'});return;}
	$('#compdialog').dialog('open');
	$('#compdialog').dialog('setTitle',formatTitle(phrase,translation)+'���');
	$('#tAffectedComp').datagrid('load',{Phrase:phrase,langid:$('#Language').combobox('getValue')});
	$('#PhraseToComp').val(phrase);
	$('#TranslationToComp').val(translation);
}
var ToMenuBtnClick=function(rowIndex,phrase,translation){
	if (translation==""){$.messager.popover({msg:$g("�շ��벻��Ӧ��"),type:'alert'});return;}
	$('#menudialog').dialog('open');
	$('#menudialog').dialog('setTitle',formatTitle(phrase,translation)+'�˵�');
	$('#tAffectedMenu').datagrid('load',{Phrase:phrase,langid:$('#Language').combobox('getValue')});
	$('#PhraseToMenu').val(phrase);
	$('#TranslationToMenu').val(translation);
}
var ToPageBtnClick=function(rowIndex,phrase,translation){
	if (translation==""){$.messager.popover({msg:$g("�շ��벻��Ӧ��"),type:'alert'});return;}
	$('#pagedialog').dialog('open');
	$('#pagedialog').dialog('setTitle',formatTitle(phrase,translation)+'ҳ��');
	$('#tAffectedPage').datagrid('load',{Phrase:phrase,langid:$('#Language').combobox('getValue')});
	$('#PhraseToPage').val(phrase);
	$('#TranslationToPage').val(translation);
}
var ToAllBtnClick=function(rowIndex,phrase,translation){
	if (translation==""){$.messager.popover({msg:$g("�շ��벻��Ӧ��"),type:'alert'});return;}
	var msg=formatTitle(phrase,translation)+"����Ӱ���������˵���ҳ����";
	$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
		if(r){
			$cm({
				ClassName:"websys.DHCTranslation",
				MethodName:"BuildAllByPhrase",
				Phrase:phrase,
				langid:$('#Language').combobox('getValue')
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('�ɹ�','Ӧ�óɹ�!');
					}else{
						$.messager.alert('ʧ��','Ӧ��ʧ��!');
					}
				}
			);
		} else {
			return;
		}
	});

}
function initTab0(){
	unInitArr[0]=false;
	$("#Phrase").keydown(function(event) {    
		if (event.keyCode == 13) {    
			$('#FindBtn').click();
		}    
    });
	$('#tDictionaryTranslated').mgrid({
		getReq : {ClassName:"websys.DictionaryTranslated",QueryName:"Find"},
		saveReq: {ClassName:"websys.DHCTranslation",MethodName:"AddTranslationItem","dto.gridId":"tPageTrans"},
		updReq : {ClassName:"websys.DHCTranslation",MethodName:"AddTranslationItem","dto.gridId":"tPageTrans"},
		insReq : {hidden:true},
		delReq : {hidden:true},
		editGrid:true, border:true,
		url:$URL,
		title:'�ֵ�Ԫ���б�',
		columns:[[
			{field:'ID',title:'�ֵ��ID',hidden:true} ,
			{field:'Phrase',title:'����',width:400,formatter:function(value){
				return replaceSpace(value);
			}} ,
			{field:'TransID',title:'�����ID',hidden:true} ,
			{field:'Translation',title:'����',width:300,editor:{type:'text' ,options:{} } ,formatter:function(value){
				return replaceSpace(value);
			}} ,
			{field:'ToComp',title:'Ӧ�õ����',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="ToCompBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')"><img src="../images/uiimages/blue_arrow.png">���</a>  ';
				return str;
			}} ,
			{field:'ToMenu',title:'Ӧ�õ��˵�',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="ToMenuBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')"><img src="../images/uiimages/blue_arrow.png">�˵�</a>  ';
				return str;
			}} ,
			{field:'ToPage',title:'Ӧ�õ�ҳ��',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="ToPageBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')"><img src="../images/uiimages/blue_arrow.png">ҳ��</a>  ';
				return str;
			}} ,
			{field:'ToAll',title:'Ӧ�õ�����',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="ToAllBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')"><img src="../images/uiimages/blue_arrow.png">����</a>  ';
				return str;
			}} 
		]],
		onBeforeLoad:function(param){
			var queryParams = $(this).datagrid('options').queryParams;
			var langid=$('#Language').combobox('getValue');
			if(!(langid>0)){
				langid=session['LOGON.LANGID'];
				$('#Language').combobox('setValue',langid);
			}
			var phrase = $('#Phrase').val();
			$.extend(param,{ langidX : langid, phrase : phrase, untranslated : $("#OnlyUnTranslated").checkbox('getValue')?"on":""}),
			$.extend(queryParams,param);
		},
		insOrUpdHandler:function(row){
			var param = this.saveReq;	
			$.extend(param,{
				"langid":this.queryParams.langidX,
				phraseid:row.ID,
				"trans":row.Translation,
				"transid":row.TransID
			});
			curGridId = 'tDictionaryTranslated';
			$cm(param,defaultCallBack);
		}		
	});
	$('#FindBtn').click(function(){$('#tDictionaryTranslated').datagrid('load');});
	$('#BuildAll').click(function(){
		var msg="ȷ�����ݷ�����ؽ�����������˵���ҳ�淭��ô";
		$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
			if(r){
				$.messager.progress({ 
					title:'���Ժ�', 
					msg:'�������¹��������Ժ�...',
					text:'Appling'
				});
				$cm({ClassName:"websys.DHCTranslation",MethodName:"BuildAll",langid:$('#Language').combobox('getValue')}, function(data,textStatus){
						$.messager.progress('close');
						if(data>0){
							//alert(data);
							$.messager.alert('�ɹ�','�ؽ��ɹ�!');
						}else{
							$.messager.alert('ʧ��','�ؽ�ʧ��!');
						}
					}
				);
			}
		});
	});
	$('#Language').combobox('setValue',session['LOGON.LANGID']);	
	//��Ӱ������
	$('#tAffectedComp').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:$URL+'?ClassName=websys.DHCTranslation&QueryName=FindAffectedComp',
		idField:'cmpid' ,
		height:414,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: 'Ӧ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var rows=$('#tAffectedComp').datagrid('getSelections');
								if (rows.length<=0){
									$.messager.alert('ʧ��','����ѡ��һ������!');
									return false;
								}
								var cmpids=[];
								for (var i=0;i<rows.length;i++) {
									cmpids.push(rows[i].cmpid);
								}
								var cmpidsStr=cmpids.join("^");
								//alert(cmpidsStr);
								var phrase=$('#PhraseToComp').val();
								var translation=$('#TranslationToComp').val();
								var msg=formatTitle(phrase,translation)+"��ѡ�������";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildComponentsByPhrase",
											cmpids:cmpidsStr,
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedComp').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});								
							}
				},"-",{
					id: '',
					text: 'Ӧ��ȫ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var phrase=$('#PhraseToComp').val();
								var translation=$('#TranslationToComp').val();
								var msg=formatTitle(phrase,translation)+"����Ӱ��������";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllComponentsByPhrase",
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedComp').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'cmpid',title:'���id',hidden:true},
			{field:'cmpname',title:'�����'} ,
			{field:'CurrentTranslation',title:'��ǰ�������',formatter:function(value){
				return replaceSpace(value);
			}} 
		]]
	});

		//��Ӱ��Ĳ˵�
	$('#tAffectedMenu').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:$URL+'?ClassName=websys.DHCTranslation&QueryName=FindAffectedMenu',
		idField:'menuid' ,
		height:414,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: 'Ӧ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var rows=$('#tAffectedMenu').datagrid('getSelections');
								if (rows.length<=0){
									$.messager.alert('ʧ��','����ѡ��һ������!');
									return false;
								}
								var menuids=[];
								for (var i=0;i<rows.length;i++) {
									menuids.push(rows[i].menuid);
								}
								var menuidsStr=menuids.join("^");
								//alert(menuidsStr);
								var phrase=$('#PhraseToMenu').val();
								var translation=$('#TranslationToMenu').val();
								var msg=formatTitle(phrase,translation)+"��ѡ�еĲ˵���";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildMenusByPhrase",
											menuids:menuidsStr,
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedMenu').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});

							}
				},"-",{
					id: '',
					text: 'Ӧ��ȫ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var phrase=$('#PhraseToMenu').val();
								var translation=$('#TranslationToMenu').val();
								var msg=formatTitle(phrase,translation)+"����Ӱ��Ĳ˵���";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllMenusByPhrase",
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedMenu').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});								

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'menuid',title:'�˵�id',hidden:true},
			{field:'menuname',title:'�˵���'} ,
			{field:'CurrentTranslation',title:'��ǰ�˵�����'}
		]]
	});
	
	//��Ӱ���ҳ��
	$('#tAffectedPage').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:$URL+'?ClassName=websys.DHCTranslation&QueryName=FindAffectedPage',
		idField:'ind' ,
		height:414,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: 'Ӧ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var rows=$('#tAffectedPage').datagrid('getSelections');
								console.log(rows);
								if (rows.length<=0){
									$.messager.alert('ʧ��','����ѡ��һ������!');
									return false;
								}
								var cspnames=[];
								for (var i=0;i<rows.length;i++) {
									cspnames.push(rows[i].cspname);
								}
								var cspnamesStr=cspnames.join("^");
								//alert(cspnamesStr);
								var phrase=$('#PhraseToPage').val();
								var translation=$('#TranslationToPage').val();
								var msg=formatTitle(phrase,translation)+"��ѡ���ҳ����";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildPagesByPhrase",
											cspnames:cspnamesStr,
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedPage').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});									

							}
				},"-",{
					id: '',
					text: 'Ӧ��ȫ��',
					iconCls: 'icon-arrow-right-top',
					handler: function(){
								var phrase=$('#PhraseToPage').val();
								var translation=$('#TranslationToPage').val();
								var msg=formatTitle(phrase,translation)+"����Ӱ���ҳ����";
								$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
									if(r){
										$cm({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllPagesByPhrase",
											Phrase:phrase,
											langid:$('#Language').combobox('getValue')
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('�ɹ�','Ӧ�óɹ�!');
												}else{
													$.messager.alert('ʧ��','Ӧ��ʧ��!');
												}
												$('#tAffectedPage').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});	

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'ind',title:'������',hidden:true},
			{field:'cspname',title:'ҳ����'} ,
			{field:'CurrentTranslation',title:'��ǰҳ�淭��'}
		]]
	});

	$('#compdialog').dialog({
		onClose:function(){
			$('#tAffectedComp').datagrid('unselectAll');
		}
	});
	$('#menudialog').dialog({
		onClose:function(){
			$('#tAffectedMenu').datagrid('unselectAll');
		}
	});
	$('#pagedialog').dialog({
		onClose:function(){
			$('#tAffectedPage').datagrid('unselectAll');
		}
	});
}
function initTab1(){
	unInitArr[1]=false;
	$('#compFindBtn').click(function(){$('#tComponentTrans').datagrid('load');});
	$('#Component').combogrid({
		width:250,
		disabled:false,		
		delay: 300,
		panelWidth:250,
		mode: 'remote',
		queryParams:{ClassName:'websys.Component',QueryName: 'VBFindLE',name:""},
		url:$URL,
		idField: 'ID',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param.q});
			return true;
		},
		onSelect:function(){$('#compFindBtn').click();},
		showHeader:false,
		columns: [[{field:'Name',title:'���',width:220}]]
	});
	$('#tComponentTrans').mgrid({
		getReq : {ClassName:"websys.DHCTranslation",QueryName:"FindCompItems"},
		saveReq: {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","Type":"COMP","dto.gridId":"tPageTrans"},
		updReq : {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","Type":"COMP","dto.gridId":"tPageTrans"},
		insReq : {hidden:true},
		delReq : {hidden:true},
		editGrid:true, border:true,
		title:'���Ԫ���б�',
		columns:[[
			{field:'type',title:'����',width:70,formatter:function(value,row,index){
				if (value=="I"){
					return "Item"
				}else if(value=="T"){
					return "TableItem"
				}else{
					return "Message"
				}
			}},
			{field:'name',title:'Ԫ�ش���',width:180},
			{field:'caption',title:'Ԫ������',width:390,formatter:function(value){return replaceSpace(value);}},
			{field:'langDesc',title:'Ŀ������',width:100,formatter:function(value,row){return "-->"+value+"-->";}},
			{field:'translation',title:'����',width:342,editor:{type:'text' ,options:{} } ,formatter:function(value){return replaceSpace(value);}}
		]],
		onBeforeLoad:function(param){
			var queryParams = $(this).datagrid('options').queryParams;
			var langid=$('#compLanguage').combobox('getValue');
			if(!(langid>0)){
				langid=session['LOGON.LANGID'];
				$('#menuLanguage').combobox('setValue',langid);
			}
			var cmpid=$('#Component').combogrid('getValue');
			param.cmpid = cmpid;
			param.langid = langid;
			$.extend(queryParams,param);
			return ;
		},
		insOrUpdHandler:function(row){
			var param = this.saveReq;				
			$.extend(param,{
				"langid":this.queryParams.langid,
				"objid":row.objid,
				"itemname":row.name,
				"translation":row.translation
			});
			curGridId = 'tComponentTrans';
			$cm(param,defaultCallBack);
		}
	});
}
function initTab2(){
	unInitArr[2]=false;
	$('#menuFindBtn').click(function(){$('#tMenuTrans').datagrid('load');});
	$("#Menu").keydown(function(event) {
		if (event.keyCode == 13) {    
			$('#menuFindBtn').click();
		}    
    });
	$('#tMenuTrans').mgrid({
		getReq : {ClassName:"websys.DHCTranslation",QueryName:"FindMenuByNameCapTrans"},
		saveReq: {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","Type":"MENU","dto.gridId":"tPageTrans"},
		updReq : {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","Type":"MENU","dto.gridId":"tPageTrans"},
		insReq : {hidden:true},
		delReq : {hidden:true},
		editGrid:true, border:true,
		title:'�˵�Ԫ���б�',
		columns:[[
			{field:'menuname',title:'�˵���',width:180},
			{field:'menucaption',title:'�˵�����',width:420},
			{field:'langDesc',title:'Ŀ������',width:100,formatter:function(value,row){return "-->"+value+"-->";}},
			{field:'CurrentTranslation',title:'����',width:352,editor:{type:'text',options:{}}}
		]],
		onBeforeLoad:function(param){
			var queryParams = $(this).datagrid('options').queryParams;
			var groupId = $('#groupcb').combobox('getValue');
			var langid=$('#menuLanguage').combobox('getValue');
			if(!(langid>0)){
				langid=session['LOGON.LANGID'];
				$('#menuLanguage').combobox('setValue',langid);
			}
			var desc = $('#Menu').val();
			param.desc = desc;
			param.langid = langid;
			param.groupId = groupId;
			$.extend(queryParams,param);
			return ;
		},
		insOrUpdHandler:function(row){
			var param = this.saveReq;
			$.extend(param,{
				"langid":this.queryParams.langid,
				"objid":row.menuid,
				"itemname":row.menuname,
				"translation":row.CurrentTranslation
			});
			curGridId = 'tMenuTrans';
			$cm(param,defaultCallBack);
		}
	});
}
function initTab3(){
	unInitArr[3]=false;
	$('#pageFindBtn').click(function(){
		$('#tPageTrans').datagrid('load');
	});	
	$('#pageExpBtn').click(function(){
		var cspname = $('#Page').combogrid('getValue');
		$cm({
			ResultSetType:"ExcelPlugin",  //��ʾͨ��DLL����Excel����֧��IE��Chromeϵ��Chromeϵ������밲װ�м��
			//ResultSetTypeDo:"Print",    //Ĭ��Export����������Ϊ��Print
			//localDir:"D:\\tmp\\",	      //�̶��ļ�·��
			//localDir:"Self",            //�û�ѡ��·��
			//localDir:""                 //Ĭ������
			ExcelName:cspname+"�ķ���",				 //Ĭ��DHCCExcel
			ClassName:"websys.DHCTranslation",
			QueryName:"FindPageItems",
			cspname:cspname,
			langid:$('#pageLanguage').combobox('getValue')
		});
	});
	$('#pageEditBtn').click(function(){
		var cspname = $('#Page').combogrid('getValue');
		if (cspname=="") {$.messager.popover({msg:'����ѡ��һ��ҳ��',type:'error'});return;};
		$.messager.prompt("��ʾ", cspname+"������������Ϊ��", function (r) {
			if (r) {
				$cm({ClassName:'websys.Page',MethodName:'Save',CspName:cspname,CspCaption:r},defaultCallBack);
				
			}
		});
	});
	$('#pageImpBtn').click(function(){
		var arr = websys_ReadExcel('');
		var plist = [];
		for (var i=0;i<arr.length; i++){
			plist.push(arr[i].join(String.fromCharCode(2)));
		}
		if (plist.length==0){ $.messager.popover({msg:"û�пɵ�������",type:'error'}); return ;}
		$cm({
			ClassName:"websys.DHCTranslation",
			MethodName:"ImportPageTrans",
			dataType:'text',
			PLIST:plist
		},function(rtn){
			if (rtn>0){
				$.messager.popover({msg:"����ɹ�",type:'success'});
			}else{
				$.messager.popover({msg:"����ʧ��."+rtn,type:'error'});
			}
		});
	});
	$('#Page').combogrid({     //��ѯcspӦ���������޹أ�����ֻ��^websys.TranslationD("PAGE",langid,cspname,itemname)���Global������ʱ��session�����԰�
		width:300,
		disabled:false,		
		delay: 500,
		panelWidth:300,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCTranslation',QueryName: 'FindPagesByCspname',cspname:""},
		url:$URL,
		//url: 'jquery.easyui.querydatatrans.csp',
		idField: 'tcspname',
		textField: 'tcspDesc',
		onBeforeLoad:function(param){
			param = $.extend(param,{cspname:param.q});
			return true;
		},
		onSelect:function(){$('#pageFindBtn').click();},
		columns: [[{field:'tcspDesc',title:'ҳ��',width:250}]]
	});
	$('#tPageTrans').mgrid({
		className:'websys.DHCTranslation',
		getReq : {ClassName:"websys.DHCTranslation",QueryName:"FindPageItems"},
		insReq : {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","dto.gridId":"tPageTrans"},
		saveReq: {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","dto.gridId":"tPageTrans"},
		updReq : {ClassName:"websys.DHCTranslation",MethodName:"BulidOneByItemname","dto.gridId":"tPageTrans"},
		delReq : {ClassName:"websys.DHCTranslation",MethodName:"Del","dto.gridId":"tPageTrans"},
		editGrid:true,
		border:true,
		title:'ҳ��Ԫ���б�',
		columns:[[
			{field:'ind',title:'ind',hidden:true},
			{field:'cspName',title:'��������',width:300,editor:{type:'text'},formatter:function(value,row){
				if (row['cspCaption']) return value+'['+row['cspCaption']+']';
				return value;
			}},
			{field:'itemname',title:'Ԫ����',width:200,editor:{type:'text'}, editabler:function(row){return row.ind==""?true:false;}},
			{field:'langDesc',title:'Ŀ������',width:100,formatter:function(value,row){return "-->"+value+"-->";}},
			{field:'translation',title:'����',width:300,editor:{type:'text'}}
		]],
		codeField:'itemname',
		onBeforeLoad:function(param){
			var queryParams = $(this).datagrid('options').queryParams;
			var langid=$('#pageLanguage').combobox('getValue');
			if(!(langid>0)){
				langid=session['LOGON.LANGID'];
				$('#pageLanguage').combobox('setValue',langid);
			}
			var cspname=$('#Page').combogrid('getValue');
			if (langid && cspname){
				param.cspname = cspname;
				param.langid = langid;
				$.extend(queryParams,param);
				return ;
			}
			return false;
		},
		onLoadSuccess:function(data,param){
			var p = $(this).datagrid('options').queryParams;
			$(this).datagrid("getPanel").panel("setTitle",p.cspname+" ҳ���Ԫ���б�");
		},
		insOrUpdHandler:function(row){
			var param = this.insReq;
			if (!row.itemname){
				$.messager.popover({msg:'Ԫ��������Ϊ�գ�',type:'info'});
				return ;
			}
			$.extend(param,{
				"Type":"PAGE",
				"langid":row.langId,
				"objid":row.cspName,
				"itemname":row.itemname,
				"translation":row.translation
			});
			curGridId = "tPageTrans";
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var cspname=$('#Page').combogrid('getValue');
			var langDesc=$('#pageLanguage').combobox('getText');
			var langid=$('#pageLanguage').combobox('getValue');
			return {ID:"",ind:"",cspName:cspname,itemname:"",translation:"",langDesc:langDesc,langId:langid};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "�ò������ָܻ�,ȷ��ɾ����"+row.itemname+"���ķ���?", function (r) {
				if (r) {
					var cspname=$('#Page').combogrid('getValue');
					var langid=$('#pageLanguage').combobox('getValue');
					$.extend(_t.delReq,{"Type":"PAGE","langid":langid,"objid":cspname,"itemname":row.itemname});
					curGridId = 'tPageTrans';
					$cm(_t.delReq,delDefaultCallBack);
				}
			});
		}
	});
}
function initTab4(){
	var erpTypeData=[
		{ID:"0",classname:"ȫ��",propertyname:"ȫ��",desc:"ȫ��"},
		{ID:"1",classname:"epr.Chart",propertyname:"Name",desc:"ͼ��ͷ"},
		{ID:"2",classname:"User.MRCObservationGroup",propertyname:"GRPDesc",desc:"User.MRCObservationGroup.GRPDesc"},
		{ID:"3",classname:"User.MRCObservationItem",propertyname:"ITMDesc",desc:"User.MRCObservationItem.ITMDesc"},
		{ID:"4",classname:"epr.CTChartItemType",propertyname:"PPDesc",desc:"epr.CTChartItemType.PPDesc"},
		{ID:"5",classname:"epr.CTPages",propertyname:"Description",desc:"epr.CTPages.Description"},
		{ID:"6",classname:"epr.CTProfileParams",propertyname:"PPDesc",desc:"epr.CTProfileParams.PPDesc"}
	];
	var EPRTypeOnChange=function(){
		$('#EPRFindBtn').click();
	}
	$("#EPRPhrase").keydown(function(event) {    
		if (event.keyCode == 13) {    
			$('#EPRFindBtn').click();
		}    
    }); 	
	$('#EPRType').combogrid({
		width:250,
		disabled:false,	
		panelWidth:400,
		//data:erpTypeData,
		mode:'remote',
		url:$URL,
		queryParams:{ClassName:"websys.DHCTranslation",QueryName:"FindEPRClassProp",desc:""},
		idField: 'ID',
		textField: 'desc',
		onSelect:EPRTypeOnChange,
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'classname',title:'��',width:200},{field:'propertyname',title:'����',width:90},{field:'desc',title:'˵��',width:90},{field:'ID',title:'ID',hidden:true}]]
	}).combogrid('setValue',0);
	
	$('#tEPRTrans').mgrid({
		ClassName:"websys.DHCTranslation",
		getReq : {ClassName:"websys.DHCTranslation",QueryName:"FindEprItems"},
		insReq : {ClassName:"websys.DHCTranslation",MethodName:"SaveEprTrans","dto.gridId":"tPageTrans"},
		saveReq: {ClassName:"websys.DHCTranslation",MethodName:"SaveEprTrans","dto.gridId":"tPageTrans"},
		updReq : {ClassName:"websys.DHCTranslation",MethodName:"SaveEprTrans","dto.gridId":"tPageTrans"},
		delReq : {ClassName:"websys.DHCTranslation",MethodName:"DelEprTrans","dto.gridId":"tPageTrans"},
		editGrid:true,
		border:true,
		title:'EPRԪ���б�',
		codeField:['classname','propertyname','Phrase'],	
		columns:[[
			{field:'ID',title:'TransERP��ID',hidden:true} ,
			{field:'classname',title:'��',width:210,editor:{type:'text'}} ,
			{field:'propertyname',title:'����',width:100,editor:{type:'text'}} ,
			{field:'Phrase',title:'����',width:380,formatter:function(value){
				return replaceSpace(value);
			},editor:{type:'text' }} ,
			{field:'langDesc',title:'Ŀ������',width:100,formatter:function(value,row){return "-->"+value+"-->";}},
			{field:'Translation',title:'����',width:285,editor:{type:'text' ,options:{} } ,formatter:function(value){
				return replaceSpace(value);
			}}
		]],
		onBeforeLoad:function(param){
			var queryParams = $(this).datagrid('options').queryParams;
			var langid=$('#EPRLanguage').combobox('getValue');
			if(!(langid>0)){
				langid=session['LOGON.LANGID'];
				$('#EPRLanguage').combobox('setValue',langid);
			}
			var phrase = $('#EPRPhrase').val();
			var eprtypeid=$('#EPRType').combogrid('getValue');
			var classname ="",propertyname="";
			if (eprtypeid>0){
				var eprTypeDesc = $('#EPRType').combogrid('getText');
				classname = eprTypeDesc.slice(0,eprTypeDesc.lastIndexOf('.')); //erpTypeData[eprtypeid].classname;
				propertyname = eprTypeDesc.slice(eprTypeDesc.lastIndexOf('.')+1); //erpTypeData[eprtypeid].propertyname;
			}
			$.extend(param,{langid:langid, phrase:phrase, untranslated : $("#EPROnlyUnTranslated").checkbox('getValue')?"on":"",qclassname:classname,qpropertyname:propertyname}),
			$.extend(queryParams,param);
		},
		insOrUpdHandler:function(row){
			var param = this.insReq;
			$.extend(param,{
				"langid":row.langId,
				"rowid":row.ID,
				"trans":row.Translation,
				qcn:row.classname,
				qpn:row.propertyname,
				txt:row.Phrase
			});
			curGridId = 'tEPRTrans';
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var q = this.queryParams;
			var langDesc = $('#EPRLanguage').combobox('getText');
			return {ID:"",classname:q.qclassname,propertyname:q.qpropertyname,Phrase:"",Translation:"",langDesc:langDesc,langid:q.langid};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "�ò������ָܻ�,ȷ��ɾ����"+row.Phrase+"���ķ���?", function (r) {
				if (r) {
					$.extend(_t.delReq,{TransId:row.ID,"langid":row.langId});
					curGridId = 'tEPRTrans';
					$cm(_t.delReq,delDefaultCallBack);
				}
			});
		}
	});
	$('#EPRLanguage').combobox('setValue',session['LOGON.LANGID']);
	$('#EPRFindBtn').click(function(){$('#tEPRTrans').datagrid('load');});	
	$('#EPRBuildAll').click(function(){
		var msg="ȷ����EPR���ó�ˢ���б�?";
		$.messager.confirm('��ʾ��Ϣ' , msg , function(r){
			if(r){
				$.messager.progress({ 
					title:'���Ժ�', 
					msg:'�������¹��������Ժ�...',
					text:'Appling'
				});
				$cm({ ClassName:"websys.TranslationEPR", MethodName:"Build" }, function(data,textStatus){
						$.messager.progress('close');
						$.messager.alert('�ɹ�','���!');
						$('#EPRFindBtn').click();
					}
				);
			} else {
				return;
			}
		});
	});	
}
function initTab5(){
	var jobj = $("#datatranspage");
	if (jobj.length>0&&jobj[0].src=="about:blank") jobj[0].src = "dhc.bdp.bdp.bdptranslation.csp";
}