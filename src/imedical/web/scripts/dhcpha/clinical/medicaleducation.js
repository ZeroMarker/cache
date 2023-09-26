/// Creator : sufan
/// date: 2016/11/13
var EpisodeID=parent.episodeID;
function initPageDefault(){
	
	initdatelisttree();   // ��ʼ��ʱ���б�
	initButton();		  // ��ʼ��ҳ���¼�
	selectall();		  // ѡ��ҳ���ϵ�����checkbox
}

// ����ʱ������
function initdatelisttree()
{
	runClassMethod("web.DHCCM.QueryPatient","Gettiemtreelist",{"EpisodeID":EpisodeID,"Searchdate":""},function(jsonstring){
		///dws 2017-01-19 ȥ���ظ�����;
		var treeData="";
		for(var i=0;i<jsonstring.length;i++)
		{
			treeData+=jsonstring[i].text+",";
			
		}
		var treedatas=treeData.substring(0,treeData.length-1);
		var aryTreeData=treedatas.split(",");
		var strTree = []; 
		for(var i = 0,len = aryTreeData.length;i < len;i++){ 
			! RegExp(aryTreeData[i],"g").test(strTree.join(",")) && (strTree.push(aryTreeData[i])); 
		} 
		var JsonTree="";
		for(var i=0;i<strTree.length;i++)
		{
			JsonTree+=("{"+'"text":'+'"'+strTree[i]+'"'+"}"+",");
		}
		var JsonTree=JsonTree.substring(0,JsonTree.length-1);
		var jsonString="["+JsonTree+"]";
		jsonString=eval(jsonString);
		gettreedata(jsonString);
	},'json',false)
}

// ��ʼ��ʱ��list
function gettreedata(jsondata){
    $('#datelist').tree({
		data: [{
		text: '��ҩ����',
		animate:'false',
		children: jsondata
		}],
	onClick:function(node){
		var date=node.text;
		if(date=="��ҩ����"){return;}
		clearcheckbox();
		getpateduinfo(date,EpisodeID);
		
		}
	});
}
// ҳ�水ť���¼�
function initButton()
{
	$('a:contains("����")').bind("click",recommend);
	$("#searchdate").bind("keyup",finddatelist);
	
	}
// ��ȡ������ҩ������Ϣ
function getpateduinfo(input,EpisodeID)
{
	runClassMethod("web.DHCCM.QueryPatient","GetMedinfo",{"date":input,"EpisodeID":EpisodeID},function(jsonstring){
		var datanum=jsonstring.total;
		hidenmenu(datanum);
		$("#infolist").html("");
		for (var i=0;i<datanum;i++)
		{
			var content=jsonstring.rows[i].Phmegcontent;
			var phwrcode=jsonstring.rows[i].PhmegCode;
			var phmegobject=jsonstring.rows[i].Phmegobject;
			var druglist=jsonstring.rows[i].PhmegDrug.substring(1,jsonstring.rows[i].length);;
				$('<tr><td><input type="checkbox" onchange="changestatue(this)" id="medcheck" style="cursor:pointer"/>&nbsp;&nbsp;<font style="color:#FF0000;"><b>ѡ��</b></font></td></tr>'
				+'<tr><td style="display: block;margin-top:8px;">1��ҩƷ��Ϣ</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+druglist+'</p></div></td></tr>'
				+'<tr><td>2��ָ������</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+phwrcode+'</p></div></td></tr>'
				+'<tr><td style="display: block;height: 22px;">3��ָ������'+'<span>'+phmegobject+'</span></td></tr>'
				+'<tr><td>4��ע������</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+content+'</p></div></td></tr>').appendTo("#infolist");
			
			}
		},'json',false)
}

///�ж��Ƿ��������ð�ť
function hidenmenu(num)
{
	if (num=="0")
	{
		$(".menu").hide();
		}
		else
		{
			$(".menu").show();
			}
}
// ѡ��ȫѡʱ,ȷ��checkbox��ѡ��״̬����������ɫ
function selectall()
{
	$("#check").click(function(){
		var len=$("input[id='medcheck']").length;
		if($("input[id='check']").is(":checked")==true){
			for(var i=0;i<len;i++){
				$("input[id='medcheck']").eq(i).attr("checked",true);
				$("input[id='medcheck']").eq(i).parent().parent().next().next().children().children().css("background","#98FB98");
				$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().children().children().css("background","#98FB98");
				$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().next().next().next().children().children().css("background","#98FB98");
			}
		}
		else{
			for(var j=0;j<len;j++){
				$("input[id='medcheck']").eq(j).attr("checked",false);
				$("input[id='medcheck']").eq(j).parent().parent().next().next().children().children().css("background","white");
				$("input[id='medcheck']").eq(j).parent().parent().next().next().next().next().children().children().css("background","white");
				$("input[id='medcheck']").eq(j).parent().parent().next().next().next().next().next().next().next().children().children().css("background","white");
			}
		}
	});
}

// ͨ���ж�checkbox��״̬����,ȷ���Ƿ�ѡ��ȫѡ��checkbox
function changestatue(obj)
{
	var foucs=$(obj).parent().parent().next().next()
	var len=$("input[id='medcheck']").length;
	var num=0;
	for(var i=0;i<len;i++){
		if($("input[id='medcheck']").eq(i).is(":checked")==true){
			num+=1;
		}
	}
	if(num==len){
		$("input[id='check']").attr("checked",true);
	}
	else{
		$("input[id='check']").attr("checked",false);
	}
	if ($(obj).is(":checked")==true)
	{
		foucs.children().children().css("background","#98FB98");
		foucs.next().next().children().children().css("background","#98FB98");
		foucs.next().next().next().next().next().children().children().css("background","#98FB98");
	
		}
		else
		{
			foucs.children().children().css("background","white");
			foucs.next().next().children().children().css("background","white");
			foucs.next().next().next().next().next().children().children().css("background","white");
			}
}

// ����
function recommend()
{
	var len=$("input[id='medcheck']").length;
	var result=""
	for(var i=0;i<len;i++)
	{
		if ($("input[id='medcheck']").eq(i).is(":checked")==true)
		{
			var medobj=$("input[id='medcheck']").eq(i).parent().parent().next().next();
			result=result+medobj.children().children().text();
			result=result+medobj.next().next().children().children().text();
			result=result+medobj.next().next().next().children().children().text();
			result=result+medobj.next().next().next().next().next().children().children().text();
		}
	}
	
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);
	clearcheckbox();
}

//����ʱ��
function finddatelist()
{
	var seachdate=$.trim($("#searchdate").val())
		runClassMethod("web.DHCCM.QueryPatient","Gettiemtreelist",{"EpisodeID":EpisodeID,"Searchdate":seachdate},function(jsonstring){
			///dws 2017-01-19 ȥ���ظ�����;
		var treeData="";
		for(var i=0;i<jsonstring.length;i++)
		{
			treeData+=jsonstring[i].text+",";
			
		}
		var treedatas=treeData.substring(0,treeData.length-1);
		var aryTreeData=treedatas.split(",");
		var strTree = []; 
		for(var i = 0,len = aryTreeData.length;i < len;i++){ 
			! RegExp(aryTreeData[i],"g").test(strTree.join(",")) && (strTree.push(aryTreeData[i])); 
		} 
		var JsonTree="";
		for(var i=0;i<strTree.length;i++)
		{
			JsonTree+=("{"+'"text":'+'"'+strTree[i]+'"'+"}"+",");
		}
		var JsonTree=JsonTree.substring(0,JsonTree.length-1);
		var jsonString="["+JsonTree+"]";
		jsonString=eval(jsonString);
			gettreedata(jsonString);
			},'json',false)
	
}

//���checkbox��ѡ��״̬
function clearcheckbox()
{
	if ($("input[id=check]").is(":checked")==true)
	{
		$("input[id=check]").attr("checked",false);
		}
	var len=$("input[id='medcheck']").length
	for(var i=0;i<len;i++)
	{	
		if (($("input[id='medcheck']").eq(i).is(":checked")==true))
		{
			$("input[id='medcheck']").eq(i).attr("checked",false);
			$("input[id='medcheck']").eq(i).parent().parent().next().next().children().children().css("background","white");
			$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().children().children().css("background","white");
			$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().next().next().next().children().children().css("background","white");
		}
	}
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })