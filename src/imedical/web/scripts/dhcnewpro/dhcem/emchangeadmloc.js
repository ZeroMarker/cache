///���ﻼ�߸��ľ������
///����js��ֱ�ӵ���_showChangeAdmLocPanel���������Ϊ����ID
///emchangeadmloc.js
function _showChangeAdmLocPanel(EpisodeID){
	var isAllowTrsLoc=$cm({"ClassName":"web.DHCEMDocMainOutPat","MethodName":"AllowTrsLoc","EpisodeID":EpisodeID,
						"LgUserID":session['LOGON.USERID'],dataType:'text'},false);
	if(isAllowTrsLoc!=0){
		$.messager.alert("��ʾ",isAllowTrsLoc);
		return;	
	}
	
	if(!$("#_emChangeAdmLocDiv").length){
		var _emChangeAdmLocHtml="";
		_emChangeAdmLocHtml+="<div id='_emChangeAdmLocDiv'  style='margin:0px 0px 0px 0px'>";
		_emChangeAdmLocHtml+="	<div style='margin:10px 0px 10px 0px;text-align:center;'>"
		_emChangeAdmLocHtml+=		"<span style='margin-right:15px;'>"+$g("����")+"</span><input id='_EmLocID'/>"
		_emChangeAdmLocHtml+=	"</div>"
		_emChangeAdmLocHtml+=	"<div style='margin:0px 0px 10px 0px;text-align:center;'>"
		_emChangeAdmLocHtml+=		"<span style='margin-right:15px;'>"+$g("�ű�")+"</span><input id='_EmCheckNo'/>"
		_emChangeAdmLocHtml+=	"</div>"
		_emChangeAdmLocHtml+=	"<div style='text-align:center;'>"
		_emChangeAdmLocHtml+=		"<a href='#' id='_UpdateLocOk'>ȷ��</a>"
		_emChangeAdmLocHtml+=		"<span style='display: inline-block;width:15px'></span>"
		_emChangeAdmLocHtml+=		"<a href='#' id='_UpdateLocCan'>ȡ��</a>"
		_emChangeAdmLocHtml+=	"</div>"
		_emChangeAdmLocHtml+="</div>"
		$("body").append(_emChangeAdmLocHtml);
		
		$HUI.window("#_emChangeAdmLocDiv",{
			title:"ת��",
			width:250,	
			height:168,
			iconCls:"icon-w-paper",
			collapsible:false,
			minimizable:false,
			maximizable:false,
			closable:false,
			closed:true,
			modal:true
		})
		
		$HUI.combobox('#_EmLocID',{
			url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc',
			valueField: 'value',
			textField: 'text',
			blurValidValue:true,
			mode:'remote',
			onSelect:function(option){
				$HUI.combobox("#_EmCheckNo").setValue("");	      
		    }
		})
		
		$HUI.combobox('#_EmCheckNo',{
			url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare',
			valueField: 'value',
			textField: 'text',
			blurValidValue:true,
			onShowPanel:function(){
				var EmLocID =$HUI.combobox("#_EmLocID").getValue(); 
		        var url = "dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+EmLocID;
		        $HUI.combobox("#_EmCheckNo").reload(url);
			}
		});
		
		$HUI.linkbutton('#_UpdateLocOk',{
		    iconCls: 'icon-w-ok'
		});	
		
		$HUI.linkbutton('#_UpdateLocCan',{
		    iconCls: 'icon-w-close'
		});	
		
		$('#_UpdateLocOk').on("click",function(){
			var LocID=$HUI.combobox("#_EmLocID").getValue();    //����ID
			var ProvID=$HUI.combobox("#_EmCheckNo").getValue(); //�ű�ID
			var Loc=$HUI.combobox("#_EmLocID").getText();       //����
			if((!LocID)||(!ProvID)){
				$.messager.alert("��ʾ","ת����ѡ����Һͺű�")
				return;
			}
			var Params=LocID+"^"+ProvID;
			$cm({
				"ClassName":"web.DHCEMDocMainOutPat",
				"MethodName":"TrsLoc",
				"EpisodeID":EpisodeID,
				"LgUserID":session['LOGON.USERID'],
				"Params":Params,
				dataType:'text'
			},function(ret){
				if (ret==="0") {
					$.messager.alert("��ʾ","ת�Ƴɹ���","",function(){
						$HUI.window("#_emChangeAdmLocDiv").close();
					});
				}else{
					$.messager.alert("��ʾ","ת��ʧ��!"+ret);
					return;
				}
			});
		})
		
		$('#_UpdateLocCan').on("click",function(){
			$HUI.window("#_emChangeAdmLocDiv").close();
		})
	}
	var LocID=$HUI.combobox("#_EmLocID").setValue(""); 
	var ProvID=$HUI.combobox("#_EmCheckNo").setValue("");
	$HUI.window("#_emChangeAdmLocDiv").open();
}
