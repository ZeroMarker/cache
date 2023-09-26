$(function(){
	loadContent();
	$("#ChangeShowMethod").combobox({
		valueField:'value',                        
		textField:'name',
		width:80,
		height:24,
		panelHeight:42,
		data:[{"value":"Picshow","name":"��Ƭ��ͼ","selected":true},
			  {"value":"listshow","name":"�����ͼ"}],
		onSelect:function(record)
		{
			if(!window.frames["framCategory"].frames["framTemplateRecord"]) return;
			window.frames["framCategory"].frames["framTemplateRecord"].loadRecord($("#sortName").attr("categoryId")); 
		}
	}); 
});

function loadContent()
{
    var templateRecord = '<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
    addTab("tabCategory","ҩѧ��Ŀ����",templateRecord,false,true);
	var welCome = '<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID="'+patientID+'&EpisodeID='+episodeID+'" '+'style="width:100%; height:100%;scrolling:no;"></iframe>';
	addTab("tabSummary","ҩѧ����ʱ����",welCome,false,false);	
}

//����Tab
function addTab(id,title,content,closable,isSelect)
{
	$('#library').tabs('add',{
		id: id,
		title: title,
		content: content,
		closable: closable,
		selected: isSelect
	});		
}

$(function(){
	$('#library').tabs({
 		onSelect: function(title,index){
			var tab = $('#library').tabs('getTab',index);
			if (tab[0].id == "tabSummary")
			{
				$('#framSummary').attr("src","emr.record.library.summary.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&UserLocID="+userLocID);
			}
			if (tab[0].id == "tabCategory")
			{
				$('#tab-tools').css("display","inline");
			}
			else
			{
				$('#tab-tools').css("display","none");
			}
        }
	});	
});

//����ؼ��¼�
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//�뿪�ؼ��¼�
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
// �س��¼�
function my_keyDown()
{
	if(event.keyCode==13)
    {
		serachRecord();                             
    }

}

$("#searchRecord").click(function(){
	serachRecord();
});

//��������
function serachRecord()
{
	if (!window.frames["framCategory"]) return;
	var selectValue = $("#searchInput").val();
	if (selectValue == $("#searchInput")[0].defaultValue)
	{
		selectValue = "";
	}
	window.frames["framCategory"].selectRecord(selectValue);	
}
