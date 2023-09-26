/// Creator: sufan
/// Date: 2016/11/22
var EpisodeID=parent.episodeID;
function initPageDefault()
{
	initdatelist();  // 初始化时间列表
	initButton();	 // 初始化页面的按钮
	checkall();		 // 全选页面的checkbox
}

/// 获取时间列表数据
function initdatelist()
{
	runClassMethod("web.DHCCM.QueryPatient","GetPhwardDateList",{"EpisodeID":EpisodeID,"Searchdate":""},function(jsonstring){
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
		getphatreelist(jsonString);
		},'json',false)
}

///获日期tree
function getphatreelist(data)
{
	$("#datelist").tree({
		data:[{
		text:'药学查房',
		animate:'false',
		children:data
		}],
	onClick:function(node){
		date=node.text;
		clearcheckbox();
		getphainfo(date);
		}
	});
}

///获取药学查房信息
function getphainfo(date)
{
	runClassMethod("web.DHCCM.QueryPatient","GetPharoundsInfo",{"date":date,"EpisodeID":EpisodeID},function(jsonstring){
		var datanum=jsonstring.total;
		hidenmenu(datanum);
		$("#phamacinfo").html("");
		for (var i=0;i<datanum;i++)
		{
			var content=jsonstring.rows[i].Phwrguidance;
			var phwrcode=jsonstring.rows[i].PhwrCode;
			var druglist=jsonstring.rows[i].InciDesc.substring(1,jsonstring.rows[i].length);
			$('<tr><td><input type="checkbox" onchange="changestatue(this)" id="phwrcheck" style="cursor:pointer"/>&nbsp;&nbsp;<font style="color:#FF0000;"><b>选择</b></font></td></tr>'
			+'<tr><td style="display:block;margin-top:10px;">'+'<font style="font-size:14px;">'+"1、药品信息"+'</font>'+'</td></tr>'
			+'<tr><td><div style="margin:5px 0px 5px 0px;width:280px;height:auto;border:1px solid #87CEEB;border-radius:5px">'+'<p style="font-Size:12px;padding-left:5px;">'+druglist+'</div></td></tr>'
			+'<tr><td>'+'<font style="font-size:14px;">'+"2、指导内容"+'</font>'+'</td></tr>'
			+'<tr><td><div style="margin:5px 0px 5px 0px;width:280px;height:auto;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+phwrcode+'</div></td></tr>'
			+'<tr><td>'+'<font style="font-size:14px;">'+"3、注意事项"+'</font>'+'</td></tr>'
			+'<tr><td><div style="margin:5px 0px 5px 0px;width:280px;height:auto;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+content+'</div></td></tr>').appendTo("#phamacinfo");
			
			}
		
		},'json',false)
}
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
///全选页面的checkbox
function checkall()
{
	$("#check").click(function(){
	var len=$("input[id='phwrcheck']").length;
	if($("#check").is(":checked")==true)
	{
		for (var i=0;i<len;i++)
		{
			$("input[id='phwrcheck']").eq(i).attr("checked",true);
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().children().children().css("background","#98FB98");
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().children().children().css("background","#98FB98");
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().next().next().children().children().css("background","#98FB98");
			}
		}
		else
		{
			for (var j=0;j<len;j++)
			{
				$("input[id='phwrcheck']").eq(j).attr("checked",false);
				$("input[id='phwrcheck']").eq(j).parent().parent().next().next().children().children().css("background","white");
				$("input[id='phwrcheck']").eq(j).parent().parent().next().next().next().next().children().children().css("background","white");
				$("input[id='phwrcheck']").eq(j).parent().parent().next().next().next().next().next().next().children().children().css("background","white");
				}
			}
		
	});
}

///判断是否选择全选checkbox
function changestatue(obj)
{
	var foucs=$(obj).parent().parent().next().next()
	var len=$("input[id='phwrcheck']").length;
	var num=0;
	for (var i=0;i<len;i++)
	{
		if ($("input[id='phwrcheck']").eq(i).is(":checked")==true)
		{
			num++;
			}
		}
	if (num==len)
	{
		$("#check").attr("checked",true);
		}
		else
		{
			$("#check").attr("checked",false);
			}
	if ($(obj).is(":checked")==true)
	{
		foucs.children().children().css("background","#98FB98");
		foucs.next().next().children().children().css("background","#98FB98");
		foucs.next().next().next().next().children().children().css("background","#98FB98");
	
		}
		else
		{
			foucs.children().children().css("background","white");
			foucs.next().next().children().children().css("background","white");
			foucs.next().next().next().next().children().children().css("background","white");
			}
}

///初始化页面的按钮
function initButton()
{
	$('a:contains("引用")').bind("click",recommend);
	$("#searchdate").bind("keyup",finddatelist);
	}

///
function finddatelist()
{
	var seachdate=$.trim($("#searchdate").val())
		runClassMethod("web.DHCCM.QueryPatient","GetPhwardDateList",{"EpisodeID":EpisodeID,"Searchdate":seachdate},function(jsonstring){
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
			getphatreelist(jsonString);
			},'json',false)
	
}
	
///引用
function recommend()
{
	var len=$("input[id='phwrcheck']").length;
	var result=""
	for (var i=0;i<len;i++)
	{
		if ($("input[id='phwrcheck']").eq(i).is(":checked")==true)
		{
			var result=result+$("input[id='phwrcheck']").eq(i).parent().parent().next().next().children().children().text();
			var result=result+$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().children().children().text();
			var result=result+$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().next().next().children().children().text();
			}
		}
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);
	clearcheckbox();
	}

//清空checkbox的选中状态
function clearcheckbox()
{
	$("input[id=check]").attr("checked",false);
	var len=$("input[id='phwrcheck']").length;
	for(var i=0;i<len;i++)
	{	
		if (($("input[id='phwrcheck']").eq(i).is(":checked")==true))
		{
			$("input[id='phwrcheck']").eq(i).attr("checked",false);
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().children().children().css("background","white");
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().children().children().css("background","white");
			$("input[id='phwrcheck']").eq(i).parent().parent().next().next().next().next().next().next().children().children().css("background","white");
		}
	}
}
///JQuery初始化页面
$(function(){ initPageDefault(); })