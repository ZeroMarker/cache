

//�������͵�ת����I��סԺ��O�����E�����
function gettype(val)
{
    if(val == "I")
    {
		return '<span style="color:green;">סԺ</span>';
    }
    else if(val == "O"){
        return '<span style="color:red;">����</span>';
    }
    else if(val == "E")
    {
		return '<span style="color:blue;">����</span>';
    }
    
    return val;
}

//������,����episodeID��iframe��������ˢ��
function browser()
{
	//episodeID = Ext.getCmp('episodeGrid')
	//createTabs();
	//admType = 
	//alert(document.getElementById("frmTabPanel").src);
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	if(selects.length == 0)
	{
		alert('��ѡ��һ�������¼�ٽ��о������,�����²���');
		return;
	}
	else if(selects.length > 1)
	{
		alert('���ξ������ֻ�ܽ��е�����¼����������Ѿ�ѡ����'+selects.length+'�������¼,�����²���');
		return;
	}
	var frame = document.getElementById("frmTabPanel");
	frame.src='about:blank';
	frame.src='epr.newfw.epsodeListTabPanel.csp?patientID=' + patientID + '&episodeID=' + episodeID;	
}


//ѡ��ɸѡ�����󣬵��ȷ�������¼�
function confirm()
{
	//debugger;
	admType = Ext.getCmp('cboAdmType').getValue();
	argDiagnosDesc = Ext.getCmp('txtArgDiagnosDesc').getValue();
	
	Ext.getCmp('episodeGrid').getEl().mask('�������¼����У����Ե�');
	var s = Ext.getCmp('episodeGrid').getStore();
	var url = '../web.eprajax.epsodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + argDiagnosDesc;
	s.proxy.conn.url = url;
	s.load();
	
	s.on('load', function(store,record){
		//debugger;
		Ext.get('episodeGrid').unmask();
	});
	
	s.on('loadexception', function(){
		//alert(1);
		Ext.get('episodeGrid').unmask();
	});
}

//�����Ա�
function compare()
{
	Ext.getCmp('compareWin').getEl().mask('�������¼����У����Ե�');
	//var episodeIDList = '';
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		alert('��ѡ��һ�������¼�ٽ��о������,�����²���');
		return;
	}
	
	//imageList��ʽΪ"3$1$34^8^S^1^0#34^6^S^1^0#35^7^S^1^0/..",var episodeIDList��ʽΪ"49/.."
	var imageList = '';
	var episodeIDList= '';
	//debugger;
	//alert(selects[0]);
	for(var i=0; i<selects.length; i++)
	{
		episodeID = selects[i].get('EpisodeID');
		episodeIDList += episodeID+'/';
	} 
	episodeIDList = episodeIDList.substring(0,episodeIDList.length-1);	//ȥ��β���ġ�/��
	var categoryChapterInfo = '';
	
	Ext.Ajax.request({			
		url: '../web.eprajax.getCategoryChapterInfo.cls',
		timeout : 5000,
		params: { EpisodeIDList: episodeIDList},
		//waitMsg : '���ݴ�����...',//����
		success: function(response, opts) {
			categoryChapterInfo = response.responseText;
			//debugger;
			
			if(categoryChapterInfo == "")
			{
				return;
			}
			var tdList = categoryChapterInfo.split("/");
			for(var i = 0; i < tdList.length; i++)
			{
				var categoryChapterList = tdList[i].split("@");
				var image = '';
				var count = 0;
				for (var j = 0; j < categoryChapterList.length; j++)
				{
					var info = categoryChapterList[j].split('#');
					
					if(image == '')
					{
						var iList = info[3].split('$');
						image = iList[1];
						count = count + parseInt(iList[0]);
					}
					else
					{
						var iList = info[3].split('$');
						image = image + '#' + iList[1];
						count = count + parseInt(iList[0]);
					}
				}
				imageList = imageList + count + '$' + image + '/';
				
			}
			imageList = imageList.substring(0,imageList.length-1);
			//alert(imageList);
			Ext.getDom('frmCompare').src = 'epr.newfw.epsodeListComparePhoto.csp?PatientID='+ patientID +'&EpisodeIDList='+ escape(episodeIDList) +'&ImageList='+ escape(imageList);
		},
		failure: function(response, opts) {
			alert(response.responseText);
		}
	});
		//alert(categoryChapterInfo);
		
	
	
	//alert(episodeIDList);
	//alert(imageList);
	;
}




