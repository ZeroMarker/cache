/*
∑≠“Îµƒøÿº˛

*/
function CreatTranLate(tableName,tableCode,tableDesc){
	if ($("#TransWin").length==0){
		$("<div id=\"TransWin\" />").prependTo("body");
	}
	var Content='<table id="Translate"><tr><td class=""><label for="language">∑≠“Î”Ô—‘</label></td><td><input class="textbox" id="language"/></td><td></td></tr>'
	Content+='<tr><td class=""><label for="languageDesc">∑≠“Î√Ë ˆ</label></td><td><input class="textbox" id="languageDesc"/></td><td><label for="">'+tableDesc+'</label></td></tr></table>'
	$HUI.dialog('#TransWin',{
		width:350,
		modal:true,
		height:180,
		title:'∑≠“Î-'+tableDesc,
		content:Content,
		buttons:[{
			text:'±£¥Ê',
			handler:function(){
				var LanguageCode=$("#language").combobox("getValue")
				var args=tableCode+"^"+tableDesc+"^"+$('#languageDesc').val()
				var rtn=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","SaveBDPTranslation",tableName,LanguageCode,args)
				$.messager.alert("Ã· æ","≥…π¶","info");
				
			}
		},{
			text:'πÿ±’',
			handler:function(){
				$HUI.dialog("#TransWin").close();
			}
		}],
		onOpen:function(){
			$.cm({
					ClassName:"web.DHCBL.CT.SSLanguage",
					QueryName:"GetDataForCmb1",
					rowid:"",
					code:"",
					desc:"",
					rows:99999
				},function(GridData){
					var cbox = $HUI.combobox("#language", {
							valueField: 'CTLANCode',
							textField: 'CTLANDesc', 
							editable:true,
							data: GridData["rows"],
							onChange:function(newValue,OldValue){
								if (newValue==""){
									//$("#ReCheckFeeBillSub").combobox('select',"");
								}
								loadFormData()
							},onLoadSuccess:function(){
								$("#language").combobox('select',GridData["rows"][0].CTLANCode);
								loadFormData()
							}
					 });
			});
				
		}
	});
	function loadFormData(){
		var LanguageCode=$("#language").combobox("getValue")
		$.cm({
			ClassName:"web.DHCBL.Authorize.BDPTranslation",
			MethodName:"GetTransDesc",
			TableName:tableName, FieldName:tableCode, Languages:LanguageCode, FieldDesc:tableDesc,
			dataType:"text",
		},function(data){
			$('#languageDesc').val(data)
		})
		}
	}