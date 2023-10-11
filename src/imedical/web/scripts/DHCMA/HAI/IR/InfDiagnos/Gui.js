//页面Gui
function InitInfDiagnosWin(){
	var obj = new Object();
	
	var InfPos=$cm({
		ClassName:"DHCHAI.BTS.InfPosSrv",
		MethodName:"GetInfPosTree"
	},false);
	
	//$('#cboInfPos').combotree('loadData',InfPos);
	$('#cboInfPos').combotree({
		autoNodeHeight:true,
		lines:true,
		editable:true,
		onShowPanel: function () {
			$('#cboInfPos').combotree('loadData',InfPos);
		},keyHandler: {
       		query: function(q,e){
	            var t = $(this).combotree('tree');  
	            var nodes = t.tree('getChildren');  
	            for(var i=0; i<nodes.length; i++){ 
	                var node = nodes[i];  
	                if (node.text.indexOf(q) >= 0){ 
	                    if (node.text==q) {
		                     $(this).combotree('setValue',node.id);
	                    }
	                    $(node.target).show();
	                } else {  
	                    $(node.target).hide();  
	                }  
	            }  
	            var opts = $(this).combotree('options');  
	            if (!opts.hasSetEvents){
	                opts.hasSetEvents = true;  
	                var onShowPanel = opts.onShowPanel;  
	                opts.onShowPanel = function(){  
	                    var nodes = t.tree('getChildren');  
	                    for(var i=0; i<nodes.length; i++){  
	                        $(nodes[i].target).show(); 
	                    }  
	                    onShowPanel.call(this);  
	                };  
	                $(this).combo('options').onShowPanel = opts.onShowPanel;  
	            }
	        }
	     }
	 });
	/*
	//感染诊断
    obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2";
		   	$("#cboInfPos").combobox('reload',url);
		},
		onChange:function(newValue,oldValue){	
			$('#cboInfSub').combobox('clear');
		}
	});
	
	//诊断分类	
	obj.cboInfSub = $HUI.combobox("#cboInfSub", {
		editable: false,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',			
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfSubSrv&QueryName=QryInfSubByPosID&ResultSetType=array&aPosID="+$('#cboInfPos').combobox('getValue');
			$("#cboInfSub").combobox('reload',url);
		}
	});
     */
	//感染转归字典
	obj.cboInfEffect = Common_ComboDicID("cboInfEffect","InfDiseasePrognosis");
	//与死亡关系字典
	obj.cboDeathRelation = Common_ComboDicID("cboDeathRelation","RepDeathRelative");
	
	InitInfDiagnosWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


