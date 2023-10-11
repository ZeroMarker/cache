/// tbl-main
function srvHandler(type,id){
	$cm({
		ClassName:"BSP.SYS.BL.NacosServices",
		MethodName:type+"MicSrv",
		Id:id
	},function(json){
		if (json.status==200){
			$.messager.popover({
				msg: '�����ɹ�',
				type: 'success',
				timeout: 3000, 		//0���Զ��رա�3000s
				showType: 'slide'  //show,fade,slide
			});
			$("#grid").datagrid('reload');
		}else{
			$.messager.popover({
				msg: '����ʧ��'+json.msg,
				type: 'error',
				timeout: 3000, 		//0���Զ��رա�3000s
				showType: 'slide'  //show,fade,slide
			});
			$("#grid").datagrid('reload');
		}
	});	
}
function init(){
	var applyIf= function(object, config) {
        var property;
        if (object) {
            for (property in config) {
                if (config.hasOwnProperty(property) && object[property] === undefined) {
	                object[property] = config[property];
	            }
            }
        }
        return object;
    };
	$("#grid").mgrid({
		fitColumns:false,
		fit:true,
		editGrid:true,
		codeField:"TServiceName",
		className:"BSP.SYS.BL.NacosServices",
		queryName:"Find",
		onColumnsLoad:function(cm){
			var defaultCm = [
				{field:"TID",hidden:true},
				{field:'TServiceName',width:150,editor:{type:'text'}},
				{field:'TServiceDesc',width:150,editor:{type:'text'}},
				{field:'TServer',width:150,editor:{type:'text'}},
				{field:'TPort',width:60,editor:{type:'text'}},
				{field:'TPath',width:160,editor:{type:'text'}},
				{field:'TProtocol',width:100,editor:{type:'text'}},
				{field:'TNacosName',width:150,editor:{type:'text'}},
				{field:'TStatus',width:60,formatter:function(val){
					if (val=="StartUp"){return "����";}
					if (val=="ShutDown"){return "ͣ��";}
					return val;
				}}
			];
			for (var i=0;i<cm.length;i++){
				var defaultObj = $.hisui.getArrayItem(defaultCm,'field',cm[i].field)
				if (defaultObj){
					applyIf(cm[i],defaultObj);
				}
			}
			cm.push({
				field:'op',title:'����',width:200,formatter:function(val,row,index){
					
					if (row["TID"]){
						if (row["TStatus"]=="StartUp"){
							return '<a href="#" style="pointer-events:none;color:#cccccc;"  onclick="srvHandler(\'Up\','+row['TID']+');return false;">�ϼ�</a>&nbsp;&nbsp;\
							<a href="#" onclick="srvHandler(\'Down\','+row['TID']+');return false;">�¼�</a>';
						}else{
							return '<a href="#" onclick="srvHandler(\'Up\','+row['TID']+');return false;">�ϼ�</a>&nbsp;&nbsp;\
							<a href="#"  style="pointer-events:none;color:#cccccc;" onclick="srvHandler(\'Down\','+row['TID']+');return false;">�¼�</a>';
						}
						/*<a href="#" onclick="srvHandler(\'Start\','+row['TID']+');return false;">����</a>&nbsp;&nbsp;\
						<a href="#" onclick="srvHandler(\'Stop\','+row['TID']+');return false;">����</a>&nbsp;&nbsp;\*/
						
					}else{
						return "";
					}
				}
			});
		},
		delHandler:function(row){
			var _t=this;
			$.messager.confirm("ɾ��","�ò�����ɾ����¼��ȷ��ɾ����"+row.TServiceDesc+"����¼��?", function(r){
				if(r){
					$.extend(_t.delReq,{"dto.entity.id":row.TID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		insOrUpdHandler:function(row){
			var param;
			var _t = this;
			if(row.TID==""){
				if(row.TServiceName==""){
					$.messager.popover({msg:"���Ʋ���Ϊ��!",type:"info"});
					return;
				}
				param = _t.insReq;
			}else{
				param = $.extend(_t.updReq,{"dto.entity.id":row.TID});
			}
			$.extend(param,{"dto.entity.ServiceName":row.TServiceName,"dto.entity.ServiceDesc":row.TServiceDesc,"dto.entity.Server":row.TServer,"dto.entity.Port":row.TPort,"dto.entity.Path":row.TPath
			,"dto.entity.Protocol":row.TProtocol
			,"dto.entity.NacosName":row.TNacosName});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {TID:"",TServiceName:"",TServiceDesc:"",TServer:"",TPort:"80",TPath:"",TProtocol:"https",TNacosName:""};	
		}
	});
	$("#btn-find").click(function(){
		$("#grid").datagrid('reload');
	});
}
$(init);