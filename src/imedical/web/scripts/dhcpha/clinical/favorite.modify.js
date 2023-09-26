$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	favUserId = getFavUserID();
	////��ʼ���ղ�����
	if (para)
	{
		var image = para.Gender=="Ů"?"../scripts/dhcpha/emr/image/icon/women_cq.png":"../scripts/dhcpha/emr/image/icon/men_cq.png";
		$("#photo").append('<img src="'+image+'"/>');
		$(".tdtitle").append('<span>�ǼǺ�:</span><span class="tcol1">'+para.PatientNo+'</span>');
		var info = '<div><span>����:</span><span id="Name">'+para.Name+'</span></div>';
		info = info + '<div><span>�Ա�:</span><span id="Gender">'+para.Gender+'</span></div>';
		info = info + '<div><span>��������:</span><span id="BOD">'+para.BOD+'</span></div>';
		$("#content").append(info);
		$("#txaMemo").val(para.Memo);
		if (para.Type != "Add")
		{
			$("#divTag").css("display","none");
			$("#divLocation").css("display","none");
			document.title = '�޸ı�ע'; 
		}
	}
	//��ʼ���ղ�λ��
	initCatalogTree("cbxLocation",true);
	
	//����ղ�
	$("#btnAdd").click(function(){ 
		if (para.Type == "Add")
		{
			addFavorite();
			//��¼�û�(�ղز���.�ύ)��Ϊ
			AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.Commit","");  	
		}
		else
		{
			modityFavInfo();
			//��¼�û�(�����ղ�.�޸ı�ע.ȷ��)��Ϊ
			AddActionLog(para.UserID,para.UserLoc,"FavoritesView.ModifyMemo.Sure","");  	

		}
	});
	
	//�رմ���
	$("#btnCancel").click(function(){
		if (para.Type == "Add")
		{
			//��¼�û�(�ղز���.ȡ��)��Ϊ
			AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.Cancel",""); 
		} 
		else
		{
			//��¼�û�(�����ղ�.�޸ı�ע.ȡ��)��Ϊ
			AddActionLog(para.UserID,para.UserLoc,"FavoritesView.ModifyMemo.Cancel",""); 	
		}
		closeWindow();
	});
	
	$('#tags').tagsInput({
		width:'310px',
		height:'73px',
		defaultText:"����ؼ��֣��س����Կ�^_^"
	});
});

///��ȡ�ղ��û�ID
function getFavUserID()
{
	var result = "";
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data:"Action=GetFavUserID&UserID="+para.UserID,
        async: false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	result = data;
        } 
    });
    return result;		
}

//��ʼ��ҳ���ղ�λ��
function initCatalogTree(id,required)
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../web.DHCCM.EMRservice.Ajax.favorites.cls",
		async : true,
		data : {"Action":"GetFavCatalog","FavUserID":favUserId},
		success : function(d) {
		
			var data = eval(d);
			if (id == "cbxNewLocation")
			{
				data = [{id:0,text:"�ղؼ�",children:data}];
			}
			$('#'+id).combotree('loadData',data);
			var node = $('#'+id).combotree('tree').tree('getRoot');
			if (node)
			{
				$('#'+id).combotree('setValue',node.id);
			}
			
		},
		error : function(d) { alert("Ŀ¼����ʧ��");}
	}); 
}

//����ղ�
function addFavorite()
{
	var tags = $("#tags").val();
	var catalogId = $('#cbxLocation').combotree('getValue');
	var memo = $("#txaMemo").val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data:"Action=AddFavorite&PatientNo="+para.PatientNo+"&FavUserID="+favUserId+"&Tags="+tags+"&CatalogID="+catalogId+"&Memo="+memo+"&EpisodeID="+para.EpisodeID+"&InstanceID="+para.InstanceID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1")
        	{
				if (para.IsSetToLog == "Y")
				{
					var ModelName = "EMR.FavoritesAdd.OK";
					var Condition = "";
					Condition = Condition + '{"patientID":"' + para.PatientNo + '",';
					Condition = Condition + '"episodeID":"' + para.EpisodeID + '",';
					Condition = Condition + '"userName":"' + escape(para.userName) + '",';
					Condition = Condition + '"userID":"' + para.UserID + '",';
					Condition = Condition + '"ipAddress":"' + para.ipAddress + '",';
					Condition = Condition + '"InstanceID":"' + para.InstanceID + '",';
					Condition = Condition + '"Tags":"' + tags + '",';
					Condition = Condition + '"CatalogID":"' + catalogId + '"}';
					var ConditionAndContent = Condition;
					//alert(ConditionAndContent);
					var SecCode = "";
					$.ajax({ 
						//type: "POST", 
						url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
						data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + para.SecCode
					});
				}
        		closeWindow();
        	}
        	else
        	{
	        	$.messager.alert('��ʾ��Ϣ','�ղ�ʧ��','info');
	        }
        } 
    });
}

//�޸��ղر�ע
function modityFavInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoMemo&FavInfoID="+ para.ID+"&Memo="+$("#txaMemo").val(), 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1")
        	{
	        	window.returnValue = $("#txaMemo").val();
        		closeWindow();
        	}
        	else
        	{
	        	$.messager.alert('��ʾ��Ϣ','�޸�ʧ��','info');
	        }
        } 
    });	
}

//�رմ���
function closeWindow()
{
	window.opener = null;
	window.open('','_self');
	window.close();	
}

$("#btnNew").click(function(){
	
	//��¼�û�(�ղز���.�½�Ŀ¼)��Ϊ
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir","");
	newCatalog();	
});

//�½��ļ��д���
function newCatalog()
{
	$('#newCatalog').window({
		title: "�����ļ���",
		width: 300,  
		height: 150,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true,
		onOpen: function(){
			initCatalogTree("cbxNewLocation",false);
		},
		onClose: function(){
		}	 
	});
	$('#newCatalog').window('open');
	$('#newCatalog').css("display","block");
}

$("#btnClose").click(function(){
	
	//��¼�û�(�ղز���.�½�Ŀ¼.�ر�)��Ϊ
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir.Close","");

	$('#newCatalog').window('close');
});

$("#btnCreate").click(function(){
	//��¼�û�(�����ղ�Ŀ¼)��Ϊ
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir.Create","");
	saveNewCatalogTree()
});

//����Ŀ¼
function saveNewCatalogTree()
{
	var value = $('#cbxNewLocation').combotree('getValue');
	var parentId = ((value == null)||(value == ""))?"0":value;
	var name = $('#txtName').val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddCatalog&FavUserID="+favUserId+"&ParentID="+parentId+"&CatalogName="+name, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "0")
        	{
	        	initCatalogTree("cbxLocation",true);
        		$('#newCatalog').window('close');
        	}
        	else
        	{
	        	$.messager.alert('��ʾ��Ϣ','����ʧ��','info');
	        }
        } 
    });		
	
}
