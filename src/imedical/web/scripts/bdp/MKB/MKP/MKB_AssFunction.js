/*
Creator:石萧伟
CreatDate:2017-03-24
/********************************************************辅助功能区****************************************************************/
var matchflag=""
//行索引
var rowCount=1;
var row=1;
//动态添加行
addRow=function()
{
    rowCount++;
    row++;
    if(rowCount==2)
    {
        var newRow='<tr id="option'+row+'"><td><img id="andOr'+row+'" onclick="changeImage('+row+')" src="../scripts/bdp/Framework/icons/mkb/re-and.png" style="border: 0px;"></td><td><input id="desc'+row+'" type="text" style="width:130px" ></td><td align="center"><a id="relation'+row+'" style="border:0px;cursor:pointer">等于</a></td><td><input id="descT'+row+'" type="text" style="width:120px" ></td><td><img id="addbutton'+row+'" onclick="addRow()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border: 0px;"></td><td><img id="delbutton'+row+'" onclick="delRow('+row+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/no.png" style="border: 0px;"></td></tr>';
    }
    else
    {
        for(var i=1;i<row;i++)
        {
            if(document.getElementById("desc"+i))
            {
                var flag=true;
                var element=document.getElementById('andOr'+i);
                //break;//获取到一个且或者或的标志，然后跳出循环
            }
        }
        if(flag)
        {
            if (element.src.match("re-and"))
            {
	            //当第二行条件为【且】的时候，添加的新行也为【且】
                var newRow='<tr id="option'+row+'"><td><img id="andOr'+row+'" onclick="changeImage('+row+')" src="../scripts/bdp/Framework/icons/mkb/re-and.png" style="border: 0px;"></td><td><input id="desc'+row+'" type="text" style="width:130px" ></td><td align="center"><a id="relation'+row+'" style="border:0px;cursor:pointer">等于</a></td><td><input id="descT'+row+'" type="text" style="width:120px" ></td><td><img id="addbutton'+row+'" onclick="addRow()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border: 0px;"></td><td><img id="delbutton'+row+'" onclick="delRow('+row+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/no.png" style="border: 0px;"></td></tr>';
            }
            else
            {
	            //当第二行条件为【或】的时候，添加的新行也为【或】
                var newRow='<tr id="option'+row+'"><td><img id="andOr'+row+'" onclick="changeImage('+row+')" src="../scripts/bdp/Framework/icons/mkb/re-or.png" style="border: 0px;"></td><td><input id="desc'+row+'" type="text" style="width:130px" ></td><td align="center"><a id="relation'+row+'" style="border:0px;cursor:pointer">等于</a></td><td><input id="descT'+row+'" type="text" style="width:120px" ></td><td><img id="addbutton'+row+'" onclick="addRow()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border: 0px;"></td><td><img id="delbutton'+row+'" onclick="delRow('+row+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/no.png" style="border: 0px;"></td></tr>';
            }
        }
    }
    var combobaseId=$('#searchId2').text();
    $('#optionContainer').append(newRow);
    //添加的新行下拉框动态赋值
        $('#desc'+row).combobox({
            url:$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+combobaseId+"&ResultSetType=array",
            valueField:'ID',
            textField:'Desc',
            onSelect:function(record){//20190726
                //alert(record.ID)
                var str=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getPubType",record.ID);
                var protype = str.split("*")[0];
                var treebaseid = str.split("*")[1];
                var thisnum = $(this).attr('id').split('desc')[1]
                if(protype == "S" || protype == "SS"){//树形属性内容。引用术语和引用起始节点 文本框变成下拉框，选中后，补鞥呢再进行选择
                    
                    $('#descT'+thisnum).combotree({
                        url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetTreeTerm&base="+treebaseid,
                        panelWidth:230,
                        width:87
                           
                    }); 
                    //$('#desc'+thisnum).combobox('disable');      
                }else if(protype=="C")
                {
                    var comboboxStr=treebaseid.replace(/&%/g,",")
                    $('#descT'+thisnum).combobox({
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetDataResource&ResultSetType=array&str="+encodeURI(comboboxStr),
                        valueField:'value',
                        textField:'desc',
                        panelWidth:180,
                        width:120
                           
                    }); 
                }
                else{
                    var parentobj = $('#descT'+thisnum).parent()
                    parentobj.html('');
                    parentobj.append('<input id="descT'+thisnum+'" type="text" style="width:80px">')
                    $('#descT'+thisnum).validatebox({});
    
                }         
            },    
            //每次点击下拉按钮刷新
        	onShowPanel:function(){
	        $('#desc'+row).combobox('reload');
	        }
            
        });

        $('#descT'+row).validatebox({
        });

        //初始化关系泡芙
        $("#relation"+row).popover({
            content:'<a  href="#" onClick="matchSign(this,'+row+')">等于</a><br/><br/><a  href="#" onClick="matchSign(this,'+row+')">包含</a><br/><br/><a  href="#" onClick="matchSign(this,'+row+')">包含子节点</a>'
        });

		//当鼠标移动到添加和删除行的时候，显示小手的样式
        var andor = document.getElementById('andOr'+row);
        andor.style.cursor="pointer";
        var addbar= document.getElementById('addbutton'+row);
        addbar.style.cursor="pointer";
        var delbar = document.getElementById('delbutton'+row);
        delbar.style.cursor="pointer";
}
//删除行
function delRow(rowIndex)
{
    $('#option'+rowIndex).remove();
    rowCount--;
}
//且和或图片的动态选择,必须全为且(或)
function changeImage(imageId)
{
    
    var element=document.getElementById('andOr'+imageId);
    if( rowCount==2)
    {
        if (element.src.match("re-and"))
        {
            element.src="../scripts/bdp/Framework/icons/mkb/re-or.png";
        }
        else
        {
            element.src="../scripts/bdp/Framework/icons/mkb/re-and.png";
        }
    }
    else
    {
        $.messager.confirm('提示', '条件只能全是且(或)确定要全部改变吗?', function(r){
            if (r)
            {
                if(element.src.match("re-and"))
                {
                    for(var i=2;i<row+1;i++)
                    {
                        //alert(i);
                        if(document.getElementById('andOr'+i))
                        {
                            var elements=document.getElementById('andOr'+i);
                            elements.src="../scripts/bdp/Framework/icons/mkb/re-or.png";
                        }
                    }
                    element.src="../scripts/bdp/Framework/icons/mkb/re-or.png";
                }
                else
                {
                    for(var i=2;i<row+1;i++)
                    {
                        if(document.getElementById('andOr'+i))
                        {
                            var elements=document.getElementById('andOr'+i);
                            elements.src="../scripts/bdp/Framework/icons/mkb/re-and.png";

                        }
                    }
                    element.src="../scripts/bdp/Framework/icons/mkb/re-and.png";
                }
            }
        });
    }

}
//第一行的combox和validatebox初始化
function rowOne()
{   
    var baseCom= $('#searchId2').text();
    $('#desc1').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+baseCom+"&ResultSetType=array",
        valueField:'ID',
        textField:'Desc',
        //每次点击下拉按钮刷新
        onSelect:function(record){//20190726
            //alert(record.ID)
            var str=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getPubType",record.ID);
            var protype = str.split("*")[0];
            var treebaseid = str.split("*")[1];
            if(protype == "S" || protype == "SS"){
                $('#descT1').combotree({
                    url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoExpression&pClassMethod=GetTreeTerm&base="+treebaseid,
                    panelWidth:230,
                    width:127
                       
                }); 
                //$('#desc1').combobox('disable');       
            }else if(protype=="C")
                {
                    var comboboxStr=treebaseid.replace(/&%/g,",")
                    $('#descT1').combobox({
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetDataResource&ResultSetType=array&str="+encodeURI(comboboxStr),
                        valueField:'value',
                        textField:'desc',
                        panelWidth:180,
                        width:120
                           
                    }); 
                }
            else{
                var parentobj = $('#descT1').parent()
                parentobj.html('');
                parentobj.append('<input id="descT1" type="text" style="width:120px">')
                $('#descT1').validatebox({});

            }
            
        },
        onShowPanel:function(){
	        $('#desc1').combobox('reload');
	        }
    });
    $('#descT1').validatebox({
    });

    //初始化关系泡芙
    $("#relation1").popover({
        content:'<a  href="#" onClick="matchSign(this,1)">等于</a><br/><br/><a  href="#" onClick="matchSign(this,1)">包含</a><br/><br/><a  href="#" onClick="matchSign(this,1)">包含子节点</a>'
    });
}
//泡芙点击方法
matchSign = function(obj,row){
    var ID = $('#desc'+row).combobox('getValue');
    if(ID != ""){
        var str=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getPubType",ID);
        var protype = str.split("*")[0];
        var reldesc = $(obj).text();

        if(protype !="S" && protype != "SS" && reldesc == "包含子节点"){
            $.messager.popover({msg: '文本类型，不含此项！',type:'alert'});       
        }else{
            $('#relation'+row).text(reldesc);
            $('#relation'+row).popover('hide');    
        }
    
    }else{
        $.messager.popover({msg: '请先选择一条公有属性！',type:'alert'});
    }
    
}
//初始化
function BodyLoadHandler()
{
	//初始界面基复按钮
	document.getElementById('changeWin').className="icon-basequery";//收藏功能用
    //获取页面的id和描述
    var ValueExp = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetValueExp", menuid);
    var baseAll = ValueExp.split("=")[1];
    var baseAllDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",baseAll);
    $('#searchId2').text(baseAll);
    $('#searchId1').text(baseAll);
    rowOne();
    //查询区窗口切换
    $("#changeWin").click(function(e){
        var div1=document.getElementById("view1");
        var div2 = document.getElementById("view2");
       
        if(div2.style.display=="none"){
            document.getElementById('changeWin').className="icon-combinationquery";
            div2.style.display = "block";
            div1.style.display="none";
        } else {
            document.getElementById('changeWin').className="icon-basequery";
            div2.style.display = "none";
            div1.style.display = "block";
        }
    });
    //辅助功能窗口切换
    $("#assChangebtn").click(function(e){
        var view3=document.getElementById("view3");
        var view4 = document.getElementById("view4");
        if(view4.style.display=="none"){
            document.getElementById('assChangebtn').className="icon-textedit";
            view4.style.display = "block";
            view3.style.display="none";
            //动态切换标题
            $("#southlay").panel('setTitle','<span style=" border-left: 4px solid #40A2DE;font-size: 14px;line-height: 24px;padding-left: 10px;border-radius:2px 2px 2px 2px;">文本编辑</span>')
        } else {
            document.getElementById('assChangebtn').className="icon-searchresult";
            view4.style.display = "none";
            view3.style.display = "block";
            $("#southlay").panel('setTitle','<span style=" border-left: 4px solid #40A2DE;font-size: 14px;line-height: 24px;padding-left: 10px;border-radius:2px 2px 2px 2px;">查询结果</span>')
        }
    });
    $("#addbutton1").click(function (e) {
        addRow();
    });
    //点击查询框的查询按钮
    /* $("#baseSearch").searchbox({
        searcher:function(value,name){
            SearchBase();
        }
    });*/
   /*$('#AssSearchDesc').searchcombobox({ 
		onChange:function(newvalue,oldvalue){
			var str=$(this).combobox('getText')
			SearchBase(str)
        }
	});*/
	changeSearchbox(baseAll);
	function changeSearchbox(base)
	{
		$('#AssSearch').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base
			
		});
	}
	$('#AssSearch').combobox('textbox').bind('keyup',function(e){ 
		if (e.keyCode==13){ 
			var str=$("#AssSearch").combobox('getText')
			//alert(str)
			SearchBase(str);
		}
	});
	$('#btnSearchMax').click(function(e){
		var str=$("#AssSearch").combobox('getText')
		//alert(str)
        	matchflag=1
		SearchBase(str);	
	}) 
    function SearchBase(str)
    {
        $('#footTwo').text('');
        $('#footThree').remove();
        $('#arrow1').hide();
        $('#arrow2').remove();
        $('#diaId').text("")
        $('#diaId3').text("")

        //获取tooltip上的id
        var options=$('#addType').tooltip('options');
        var baseDesc=options.content;
        //var base=$('#searchId1').text();
        var base=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getIdByDesc",baseDesc);
        //alert(base)
        //var str=$.trim($('#baseSearch').searchbox('getValue'));
        var flag="N"
        
        var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+base+"&str="+str+"&flag="+flag+"&matchflag="+matchflag+"&matchflag="+matchflag;
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
        $('#myiframe').attr("src",url);
        var desc=baseDesc.substr(0,6);
        $('#footOne').text(desc+"...");
        $('#imgId').show();
        $('#bookstr').text(str);
        //第一个足迹点击事件
        $('#footOne').click(function(e){
            var flag="N";
            var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+base+"&str="+str+"&flag="+flag+"&matchflag="+matchflag+"&matchflag="+matchflag;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#myiframe').attr("src",url);
            $('#footTwo').text('');
            $('#footThree').remove();
            $('#arrow1').hide();
            $('#arrow2').remove();
            $('diaId').text('')
            $('diaId3').text('');
        });
    }
    //点击之前的tool提示
    var tt = $HUI.tooltip('#toti',{
    content:baseAllDesc,
    position: 'bottom' //top , right, bottom, left
    });
    var toti = $HUI.tooltip('#addType',{
        content:baseAllDesc,
        position: 'bottom' //top , right, bottom, left
    });
    $("#addType").click(function (e) {
        clickBase(1);
    });

    $("#addTypeF").click(function (e) {
        clickBase(2);
    });
    function clickBase(flag)
    {   if(flag==2)
        {
            if(document.getElementById('addTypeF').src.match("yesdot"))
            {
                searchD(flag)
            }
            else
            {
                $.messager.popover({msg: '在主界面显示，无法进行配置！',type:'alert'});
            }

        }
        else
        {
            searchD(flag)
        }
           
    }
    function searchD(flag)
    {
        $("#baseWin").window({
            width:370,
            height:370,
            top:150,
            left:1000,
            //title:"知识库列表",
			iconCls:'icon-textbook',
            collapsible:false,
            minimizable:false,
            maximizable:false,
            closable:true,
            resizable:false
        });

        var BASE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTermBaseSet";
        var basecolumns =[[
            {field:'ID',title:'代码',hidden:true},
            {field:'Desc',title:'知识库',width:100,sortable:true,align:'center'}
        ]];
        $('#basegrid').datagrid({
            width:'100%',
            height:'100%',
            autoRowHeight: true,
            columns: basecolumns,  //列信息
            pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
            singleSelect:true,
            remoteSort:false,
            url:BASE_ACTION_URL,
            idField:'ID',
            fitColumns:true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize :0,
            onDblClickRow:function(index,row)
            {
                if(flag==1)
                {
                    closeBaseGridEasy(row);
                    $("#AssSearch").combobox('setValue','')
                    $('#myiframe').attr("src","");
                    $('#imgId').hide();
                    $('#footTwo').text("");
                    $('#footOne').text("");
                    $('#arrow1').hide();
                    if($('#arrow2').attr("id"))
                    {
	                   $('#arrow2').remove();
	                   $('#footThree').remove(); 
	                }
                }
                if(flag==2)
                {
                    closeBaseGridHard(row);
                    var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+baseAll+"&ResultSetType=array"
		            for (var i = 0; i < row+1; i++)
		            {
		                $('#desc'+i).combobox('clear');
		                $('#desc'+i).combobox('reload',url);
                        $('#descT'+i).val('');//清空文本框
                        
                        var parentobj = $('#descT'+i).parent()
                        parentobj.html('');
                        parentobj.append('<input id="descT'+i+'" type="text" style="width:80px">')
                        $('#descT'+i).validatebox({});    
		            }
		            $('#myiframe').attr("src","");
		            $('#imgId').hide();
                    $('#footTwo').text("");
                    $('#footOne').text("");
                    $('#arrow1').hide();
                    if($('#arrow2').attr("id"))
                    {
	                   $('#arrow2').remove();
	                   $('#footThree').remove(); 
	                }                    
                }
            }
        });
        $('div.pagination-info').remove();//移除分页工具  
    } 
    //弹出框双击方法
    function closeBaseGridHard(rowData)
    {
        //双击tooltip显示术语值
        var tt = $HUI.tooltip('#toti',{
            content:rowData.Desc,
            position: 'bottom' //top , right, bottom, left
        });
        $('#searchId2').text(rowData.ID);
        var base=rowData.ID;
        var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+base+"&ResultSetType=array"
        for (var i = 0; i < row+1; i++)
        {
            $('#desc'+i).combobox('clear');//清空下拉框
            $('#descT'+i).val('');//清空文本框
            $('#desc'+i).combobox('reload',url);

            //$('#desc'+i).combobox('enable'); 
            var parentobj = $('#descT'+i).parent()
            parentobj.html('');
            parentobj.append('<input id="descT'+i+'" type="text" style="width:80px">')
            $('#descT'+i).validatebox({});    

        }
        $('#basegrid').datagrid('unselectAll');
        //关闭window
        $('#baseWin').window('close');
    }
    function closeBaseGridEasy(rowData)
    {
        //双击tooltip显示术语值
        var tt = $HUI.tooltip('#addType',{
            content:rowData.Desc,
            position: 'bottom' //top , right, bottom, left
        });
        $('#searchId1').text(rowData.ID);
        changeSearchbox(rowData.ID);
        $('#basegrid').datagrid('unselectAll');
        //关闭window
        $('#baseWin').window('close');
    }
    //搜索按钮
    $("#btnSearchFunction").click(function (e) {
        clickHanButton();
    });
    //开始时先将第一个箭头隐藏
    $("#arrow1").hide(); 
    //点击搜索按钮
    function clickHanButton()
    {
        //重新搜索时，清楚足迹
        $('#footTwo').text('');
        $('#footThree').remove();
        $('#arrow1').hide();
        $('#arrow2').remove();
		$('#diaId').text("")
        $('#diaId3').text("")

        //获取tooltip上的id
        var options=$('#toti').tooltip('options');
        var baseDesc=options.content;
        //var base=$('#searchId2').text();
        //根据描述获取id
        var base=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getIdByDesc",baseDesc);
        //alert(base)
        var desc1=$('#desc1').combobox('getText');//$('#desc1').combobox('getText');
        if(desc1!="")
        {
            


            var strp=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getPubType",$('#desc1').combobox('getValue'));
            var protype = strp.split("*")[0];
            if(protype == "S" || protype == "SS"){
                var descT1=$('#descT1').combotree('getValue');
            }else if(protype=="C")
                var descT1=$('#descT1').combobox('getValue');
            else{
                var descT1=$('#descT1').val();
            }

            var relation = $('#relation1').text();
            var rel = ""
            if(relation == "等于"){
                var rel = "E"
            }else if(relation == "包含"){
                var rel = "C"
            }else{
                var rel = "CC"
            }
            var str=desc1+':'+rel+':'+descT1;
        }
        else
        {
            var str=""
        }
        for(var i=2;i<row+1;i++)
        {
            if(document.getElementById("desc"+i))
            {
                element=document.getElementById('andOr'+i);
                var desc = $('#desc' + i).combobox('getText');

                var strp=tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","getPubType",$('#desc' + i).combobox('getValue'));
                var protype = strp.split("*")[0];
                if(protype == "S" || protype == "SS"){
                    var descT= $('#descT'+i).combotree('getValue');
                }else if(protype=="C")
                {

                    var descT= $('#descT'+i).combobox('getValue');
                }
                else{
                    var descT= $('#descT'+i).val();
                }
    
                var relation = $('#relation'+i).text();
                var rel = ""
                if(relation == "等于"){
                    var rel = "E"
                }else if(relation == "包含"){
                    var rel = "C"
                }else{
                    var rel = "CC"
                }
    

                if(element.src.match("re-and") && desc!="")
                {
                    str = str + ';*' + desc + ':' + rel + ':' + descT;
                }
                else if(element.src.match("re-or") && desc!="")
                {
                    str=str+';|'+desc+':'+ rel + ':' +descT
                }
            }
        }
        //alert(str)
        //return false
        $('#bookstr').text(str);//收藏搜索串，收藏恢复功能用
        $.cm({
            ClassName:"web.DHCBL.MKB.MKBAssInterface",
            MethodName:"GetNewTerm",
            base:base,
            str:str
        },function(jsonData){
            if(jsonData=="")
            {
                $('#footOne').text('');
                $('#imgId').hide();
                $('#myiframe').attr('src','');//如果数据不存在则清除辅助框
                alert("没有符合条件的数据!");
                return false;
            }
            else
            {
                if(document.getElementById('mainbar').src.match("main"))
                {
                        
                    var baseTypeN=tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID",base)
                    if(baseTypeN=="L")
                    {
                        /*$('#mygrid').datagrid('load',{
							ClassName:"web.DHCBL.MKB.MKBAssInterface",
							MethodName:"GetNewTerm",
							base:base,
							str:str	                    	    
                        })*/
                        
                        $('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetNewTerm&base="+base+"&str="+str                       
                        $('#mygrid').datagrid('load',  {		
                            'base':base,	
                            'str':str
                        });
	                    $('#mygrid').datagrid('unselectAll');
						$("#TextSearch").combobox('setValue', '');
						$('#mygrid').datagrid('unselectAll');
						termdr=""
						//清空中间属性列表，变为图片，改变标题
						$('#mylayoutproperty').panel('setTitle','属性维护')
						if (document.getElementById('mygridProperty').style.display=="")   //如果是mygrid加载的状态
						{	
							$('#mygridProperty').datagrid('loadData', { total: 0, rows: [] }); 
							$('#mygridProperty').datagrid('unselectAll');
							document.getElementById('mygridProperty').style.display='none';  //隐藏mygrid
							$("#div-img").show();  //展示初始图片			
						}
						$('#mygridProperty').datagrid('load',{ 
							ClassName:"web.DHCBL.MKB.MKBTermProperty",
							QueryName:"GetList",
							'termdr':"",
							'desc':""
						});
						$('#mygridProperty').datagrid('unselectAll');
						$("#myiframepropertycontent").attr("src","")
                    }
                    else
                    {
	                    $.cm({
                        ClassName:"web.DHCBL.MKB.MKBAssInterface",
                        MethodName:"GetTreeTerm",
                        base:base,
                        str:str
                        },function(JsonData){
	                    //alert(base+"*"+str)
                        /*$('#mygrid').treegrid('load',{
							ClassName:"web.DHCBL.MKB.MKBAssInterface",
							QueryName:"GetTreeTerm",
							'base':base,
							'str':str		                 	    
	                    })*/
	                    $('#mygrid').treegrid('loadData',JsonData)
                        })
						$("#TextSearch").combobox('setValue', '');
						$('#mygrid').treegrid('unselectAll');
						//清空中间属性列表，变为图片，改变标题
						$('#mylayoutproperty').panel('setTitle','属性列表')
						if (document.getElementById('mygridProperty').style.display=="")   //如果是mygrid加载的状态
						{	
							$('#mygridProperty').datagrid('loadData', { total: 0, rows: [] }); 
							$('#mygridProperty').datagrid('unselectAll');
							document.getElementById('mygridProperty').style.display='none';  //隐藏mygrid
							$("#div-img").show();  //展示初始图片			
						}

									$('#mygridProperty').datagrid('load',{ 
										ClassName:"web.DHCBL.MKB.MKBTermProperty",
										QueryName:"GetList",
										'termdr':"",
										'desc':""
									});
									$('#mygridProperty').datagrid('unselectAll');
									$("#myiframepropertycontent").attr("src","")							
				                }
                   // });
                   
                }
                else
                {
                    
                    var flag="Y"
                    var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+base+"&str="+str+"&flag="+flag+"&matchflag="+matchflag;
                    if ('undefined'!==typeof websys_getMWToken){
                        url += "&MWToken="+websys_getMWToken()
                    }
                    $('#myiframe').attr("src",url);
                    var desc=baseDesc.substr(0,6);
                    $('#footOne').text(desc+"...");
                    $('#imgId').show();
                    //点击诊断足迹
                    $('#footOne').click(function(e){
                        var flag="Y"
                        var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+base+"&str="+str+"&flag="+flag+"&matchflag="+matchflag;
                        if ('undefined'!==typeof websys_getMWToken){
                            url += "&MWToken="+websys_getMWToken()
                        }
                        $('#myiframe').attr("src",url);
                        $('#footTwo').text('');
                        $('#footThree').remove();
                        $('#arrow1').hide();
                        $('#arrow2').remove();
                        $('#diaId3').text('');
                        $('#diaId').text('');
                    });
                }
            }
        });
    }
    //点击属性足迹
    $('#footTwo').click(function(e){
        var diaId=$('#diaId').text();
        $('#diaId3').text('');
        var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+diaId;
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
        $('#myiframe').attr("src",url);
        $('#footThree').remove();
        $('#arrow2').remove();
    });
    //术语弹窗的搜索框监听事件,刷新数据
    $("#searchIn").keyup(function(){
        var desc=$.trim($('#searchIn').val());
        $.cm({
            ClassName:"web.DHCBL.MKB.MKBAssInterface",
            MethodName:"GetTermBaseSet",
            desc:desc
        },function(JsonData){
            $('#basegrid').datagrid('load',  { 
                'desc':desc  
             });
        });

    });
    /*$('#searchIn').searchbox({
	    searcher:function(value,name){
	    	//alert(value)
        $.cm({
            ClassName:"web.DHCBL.MKB.MKBAssInterface",
            MethodName:"GetTermBaseSet",
            desc:value
        },function(JsonData){
            $('#basegrid').datagrid('load',  { 
                'desc':value  
             });
        });	    	
	    }
	});*/
    //初始界面设置按钮为不可点击，在切换到辅时才能点击
    //$("#addTypeF").linkbutton('disable');
    //主辅点击事件mainbar
    $("#mainbar").click(function(e){
        element=document.getElementById('mainbar');
        if (element.src.match("main")) //主切换到辅
        {
            element.src="../scripts/bdp/Framework/icons/mkb/assistnt.png";
            elet=document.getElementById('addTypeF');
            elet.src="../scripts/bdp/Framework/icons/mkb/yesdot.png"
            //$("#addTypeF").linkbutton('disable');
            //$("#addTypeF").linkbutton('enable');
            var ValueExp = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetValueExp", menuid);
    		var baseAll = ValueExp.split("=")[1];
            $('#searchId2').text(baseAll);
            /*var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+baseAll+"&ResultSetType=array"
            for (var i = 0; i < row+1; i++)
            {
                $('#desc'+i).combobox('clear');
                $('#desc'+i).combobox('reload',url);
                $('#descT'+i).val('');//清空文本框
            }*/
        }
        else
        {
	        elet=document.getElementById('addTypeF');
            elet.src="../scripts/bdp/Framework/icons/mkb/nodot.png"
            element.src="../scripts/bdp/Framework/icons/mkb/main.png";
           var ValueExp = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetValueExp", menuid);
            var baseAll = ValueExp.split("=")[1];
            var baseData = $('#searchId2').text();//备份id用来比较
            $('#searchId2').text(baseAll);
            //切换到主时关闭窗口
//            if(!$("#baseWin").parent().is(":hidden"))
//            {
//	            $('#baseWin').window('close')
//	        }
            //主术语
            var tt = $HUI.tooltip('#toti',{
                content:baseAllDesc,
                position: 'bottom' //top , right, bottom, left
            });
            //$('#searchId1').text(baseAll);
            if(baseData != baseAll){
                var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+baseAll+"&ResultSetType=array"
                for (var i = 0; i < row+1; i++)
                {
                    $('#desc'+i).combobox('clear');
                    $('#desc'+i).combobox('reload',url);
                    $('#descT'+i).val('');//清空文本框

                    var parentobj = $('#descT'+i).parent()
                    parentobj.html('');
                    parentobj.append('<input id="descT'+i+'" type="text" style="width:80px">')
                    $('#descT'+i).validatebox({});    
                }
    
            }
        }
    });

    //开始时将右侧面板折叠
    $('#layout').layout('collapse','east');
    //判断浏览器高度改变辅助功能区高度
    var windowHightM = Math.max(document.documentElement.clientHeight,document.body.clientHeight)
    if (windowHightM<610)
    {
	    $('#southlay').panel('resize',{
    	height: 410
		});
	}
	else if(windowHightM>800)
	{
		$('#southlay').panel('resize',{
    	height: 600
		});
	}

    /*****************************************添加收藏**chenghegui  Start*********************************/
    // 单击收藏
    $("#addbookmarks").click(function (e) {
       if(document.getElementById('changeWin').className=="icon-basequery")
       {   
           var BaseDR = $('#searchId1').text();
       }
       else
       {
           var BaseDR = $('#searchId2').text();
       }
       var TermDR = $('#diaId').text()
       var ProDR = $('#diaId3').text()
       var IdStr = BaseDR+"-"+TermDR+"*"+ProDR
       var SearchStr = $('#bookstr').text()
      if((document.getElementById('changeWin').className=="icon-combinationquery" && SearchStr==""))
        {
          $.messager.alert('操作提示',"请您搜索后收藏!","info");   
          return;
        } 
       $.m({
            ClassName:"web.DHCBL.MKB.MKBBookMarks",
            MethodName:"SaveDataStr",
            IdStr:IdStr,
            SearchStr:SearchStr
       },function(data){
            var data=eval('('+data+')'); 
          if (data.success == 'true') {
            $.messager.popover({msg: '收藏成功！',type:'success',timeout: 1000}); 
            var MKBDesc =tkMakeServerCall("web.DHCBL.MKB.MKBBookMarks","GetDesc",IdStr,"Y");//表示"短"标识
            var MKBDescDetail =tkMakeServerCall("web.DHCBL.MKB.MKBBookMarks","GetDesc",IdStr,"N");
            var bookhtml="<p style='cursor:pointer;padding: 10px 80px 5px 20px;background-color:#4E6C97;height:15px' id='p"+data.id+"'>"+"<a href='#' title='"+MKBDescDetail+":"+SearchStr+"' class='hisui-tooltip' style='color:#fff;' onclick=RecoverMarks('"+IdStr+"','"+SearchStr+"')>"+MKBDesc+"</a>"
            +"&nbsp&nbsp&nbsp&nbsp"+"<a href='javascript:void(0)' class='deletemarks' onclick=DeleteMarks("+data.id+")><img style='padding:2px;float: right;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/white/close.png'></img></a></p>"
            $("#bookmarks").append(bookhtml);
            $("p").hover(function(){
                $(this).css("background-color","#38A1EB");
            },function(){
                $("p").css("background-color","#4E6C97");
            });
          } 
          else { 
                var errorMsg =""
                if (data.errorinfo) {
                    errorMsg =errorMsg+ '<br/>' + data.errorinfo
                    }
                    $.messager.alert('操作提示',errorMsg,"info");
                } 
        })
    });
    //滑动 显示  隐藏
   $("#imgbookmarks").mouseover(function(){
            $("#imgbookmarks").css({opacity:1});  
            $("#bookmarks").animate({left:'85%'});
			bookmarksview();
        });
        $("#bookmarks").mouseleave(function(){
           $("#imgbookmarks").css({opacity:0.5});  
           $("#bookmarks").animate({left:'100%'});
           
        });
        //展示
	bookmarksview =function(){
        $.cm({
            ClassName:"web.DHCBL.MKB.MKBBookMarks",
            QueryName:'GetList'
            },function(jsonData){
                //删除
                 DeleteMarks =function(id){
                     var data = tkMakeServerCall("web.DHCBL.MKB.MKBBookMarks","DeleteData",id)
                     var data=eval('('+data+')'); 
                      if (data.success == 'true') {
                            /*$.messager.show({ 
                              title: '提示消息', 
                              msg: '删除成功', 
                              showType: 'show', 
                              timeout: 1000, 
                              style: { 
                                right: '', 
                                bottom: ''
                              } 
                            });*/
                            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                             $("#p"+id).remove();
                        } 
                        else { 
                            var errorMsg ="删除失败！"
                            if (data.errorinfo) {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                                }
                                $.messager.alert('操作提示',errorMsg,"error");
                            }
                     } 
                     $("#bookmarks").html("");   
					for(var j = 0,len=jsonData.rows.length; j < len; j++)
					{
						var MKBBKCode = jsonData.rows[j].MKBBKCode
						var MKBBKDesc = jsonData.rows[j].MKBBKDesc
						var RowId =jsonData.rows[j].MKBBKRowId
						if(MKBBKCode){
							 var MKBDesc =tkMakeServerCall("web.DHCBL.MKB.MKBBookMarks","GetDesc",MKBBKCode,"Y");//表示"短"标识
							 var MKBDescDetail =tkMakeServerCall("web.DHCBL.MKB.MKBBookMarks","GetDesc",MKBBKCode,"N");
						}
                        var bookhtml="<p style='cursor:pointer;padding: 10px 80px 5px 20px;background-color:#4E6C97;height:25px'id='p"+RowId+"'>"+"<a href='javascript:void(0)' title='"+MKBDescDetail+":"+MKBBKDesc+"' class='hisui-tooltip'  style='color:#fff;' onclick=RecoverMarks('"+MKBBKCode+"','"+MKBBKDesc+"')>"+MKBDesc+"</a>"
                        +"&nbsp&nbsp&nbsp&nbsp"+"<a href='javascript:void(0)' class='deletemarks' onclick=DeleteMarks("+RowId+")><img  style='padding:2px;float: right;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/white/close.png'></img></a></p>"
                        $("#bookmarks").append(bookhtml);
                        $("p").hover(function(){
                            $(this).css("background-color","#38A1EB");
                        },function(){
                            $("p").css("background-color","#4E6C97");
                        });
					}
            //恢复
            RecoverMarks =function(ids,searchstr){
                $("#imgbookmarks").css({opacity:0.5});  
                $("#bookmarks").animate({left:'100%'},100);
                if((ids!="")){
                    //清除显示区已存在的数据
                    $('#footOne').text('');
                    $('#imgId').hide();
                    $('#footTwo').text('');
                    $('#footThree').remove();
                    $('#arrow1').hide();
                    $('#arrow2').remove();
                    $('#myiframe').attr('src','');
                    var BaseDr = ids.split("-")[0];
                    var TermDr = (ids.split("-")[1]).split("*")[0];
                    var ProDr = (ids.split("-")[1]).split("*")[1];
                    var BaseDrDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",BaseDr);
                    if(TermDr!="")
                    {
                        var TermDrDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",TermDr);  
                    }
                    if(ProDr!="")
                    {
                        var ProDrDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",ProDr);
                    }
                    
                    if(BaseDr!=""&&TermDr!=""&&ProDr!="")
                    {
                        var BaseDrDesc=BaseDrDesc.substr(0,6);
                        $('#footOne').text(BaseDrDesc+"...");
                        $('#imgId').show();
                        var TermDrDesc=TermDrDesc.substr(0,6);
                        $('#footTwo').text(TermDrDesc+"...");
                        $('#arrow1').show();
                        if(ProDrDesc.length<=5)
                        {
                            $('#foot').append("<td id='arrow2'>></td><td id='footThree'>"+ProDrDesc+"</td>");
                        }
                        else
                        {
                             var desc=ProDrDesc.substr(0,4);
                             $('#foot').append("<td id='arrow2'>></td><td id='footThree'>"+desc+"...</td>");
                        }
                        //判断是哪种类型的属性
                        var ProDrType=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetType",ProDr);
                        //var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+ProDr;
                        if(ProDrType=="L")
                        {
                            //双击数据跳转到内容界面（列表型）
                            var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+ProDr+"&propertyName="+ProDrDesc;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                        }
                        else if(ProDrType=="T")
                        {
                            //列表型
                            var url="../csp/dhc.bdp.mkb.mkbassdetailtree.csp"+"?property="+ProDr;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                        }
                        else if(ProDrType=="F")
                        {
                            //文本型
                            var url="../csp/dhc.bdp.mkb.mkbassdetailtext.csp"+"?property="+ProDr;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                        }
                        else if(ProDrType=="P")
                        {
                            //引用属性格式属性内容维护模块
                            var url="../csp/dhc.bdp.mkb.mkbassdetailproperty.csp"+"?property="+ProDr+"&propertyName="+ProDrDesc;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                        }
                        else if(ProDrType=="S")
                        {
                            //引用术语格式属性内容维护模块
				            var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",ProDr)  //引用术语是树形还是列表型
			            	if(configListOrTree=="T")
							{
								url="dhc.bdp.mkb.mkbassdetailtreeterm.csp?property="+ProDr
							}
							else
							{
								url="dhc.bdp.mkb.mkbassdetaillistterm.csp?property="+ProDr
							}                            
                            //var url="../csp/dhc.bdp.mkb.mkbassdetailterm.csp"+"?property="+ProDr+"&propertyName="+ProDrDesc;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                        }
                        else
                        {
                         	$('#arrow2').remove();
                         	$('#footThree').remove();
                         	//var url= "../csp/dhc.bdp.mkb.mkbassdetailothers.csp"+"?property="+ProDr;
	            			//$('#myiframe').attr("src",url);
                        }
                        $('#diaId').text(TermDr)
                        $('#diaId3').text(ProDr)
                        if((searchstr.indexOf(":")>0)&&searchstr!="")
                        {
                            $('#searchId2').text(BaseDr)
                        }
                        else
                        {
                            $('#searchId1').text(BaseDr)                        
                        }
                        addClick(BaseDr,TermDr,searchstr);
                    }
                    else if(BaseDr!=""&&TermDr!=""&&ProDr=="")
                    {
                        var BaseDrDesc=BaseDrDesc.substr(0,6);
                        $('#footOne').text(BaseDrDesc+"...");
                        $('#imgId').show();
                        var TermDrDesc=TermDrDesc.substr(0,6);
                        $('#footTwo').text(TermDrDesc+"...");
                        $('#arrow1').show();
                        var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+TermDr;
                        if ('undefined'!==typeof websys_getMWToken){
                            url += "&MWToken="+websys_getMWToken()
                        }
                        $('#myiframe').attr("src",url);
                        $('#diaId').text(TermDr)
                        if((searchstr.indexOf(":")>0)&&searchstr!="")
                        {
                            $('#searchId2').text(BaseDr)
                        }
                        else
                        {
                            $('#searchId1').text(BaseDr)                        
                        }
                        addClick(BaseDr,TermDr,searchstr);
                    }
                    else if(BaseDr!=""&&TermDr==""&&ProDr=="")
                    {
                        var BaseDrDesc=BaseDrDesc.substr(0,6);
                        $('#footOne').text(BaseDrDesc+"...");
                        $('#imgId').show();
                        //重新生成足迹点击事件
                        if((searchstr.indexOf(":")>0)&&searchstr!="")
                        {
                            $('#footOne').click(function(e){
                                var flag="Y"
                                
                                var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                                if ('undefined'!==typeof websys_getMWToken){
                                    url += "&MWToken="+websys_getMWToken()
                                }
                                $('#myiframe').attr("src",url);
                                $('#footTwo').text('');
                                $('#footThree').remove();
                                $('#arrow1').hide();
                                $('#arrow2').remove();
                                $('#diaId3').text('');
                                $('#diaId').text('');
                            });
                            var flag="Y"
                            var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                            $('#bookstr').text(searchstr);
                            $('#searchId2').text(BaseDr)
                        }
                        else
                        {
                            $('#footOne').click(function(e){
                                var flag="N"
                                
                                var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                                if ('undefined'!==typeof websys_getMWToken){
                                    url += "&MWToken="+websys_getMWToken()
                                }
                                $('#myiframe').attr("src",url);
                                $('#footTwo').text('');
                                $('#footThree').remove();
                                $('#arrow1').hide();
                                $('#arrow2').remove();
                                $('#diaId3').text('');
                                $('#diaId').text('');
                            });
                            var flag="N"
                            var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            $('#myiframe').attr("src",url);
                            $('#bookstr').text(searchstr);
                            $('#searchId1').text(BaseDr)
    
                        }
                    }
                    
                }
                
           }
            
    })
}
    //重新生成足迹点击事件 
    function addClick(BaseDr,TermDr,searchstr)
    {   
        if((searchstr.indexOf(":")>0)&&searchstr!="")
        {
            //重新生成足迹点击事件
            $('#footOne').click(function(e){
                var flag="Y"
                
                var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#myiframe').attr("src",url);
                $('#footTwo').text('');
                $('#footThree').remove();
                $('#arrow1').hide();
                $('#arrow2').remove();
                $('#diaId3').text('');
                $('#diaId').text('');
            });
        
        }
        else
        {
            $('#footOne').click(function(e){
                var flag="N"
                
                var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseDr+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#myiframe').attr("src",url);
                $('#footTwo').text('');
                $('#footThree').remove();
                $('#arrow1').hide();
                $('#arrow2').remove();
                $('#diaId3').text('');
                $('#diaId').text('');
            });
        }
        //点击属性足迹
        $('#footTwo').click(function(e){
            var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+TermDr;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#myiframe').attr("src",url);
            $('#footThree').remove();
            $('#arrow2').remove();
            $('#diaId3').text('');
        });
        $('#bookstr').text(searchstr);
    } 
    /*************************************************收藏夹 end*************************/ 
    /***********************************************放大窗口数据显及足迹 开始*****************/
    $("#maxWin").click(function(e){
        var maxFlag="Y"
        var windowHight = Math.max(document.documentElement.clientHeight,document.body.clientHeight)
        var windowWidth = Math.max(document.documentElement.clientWidth,document.body.clientWidth)
        //$('#funPanel').panel('panel').css('position','fixed');
        if (maxFlag=="N")
        {
            $('#MaxWin').window('close');
            $('#southlay').window('panel').attr('changewindow',"")
        }
        else
        {
            //alert($("#MaxWin").parent().is(":hidden"))
            $('#MaxWin').show();
            $('#arrowMax1').hide();
            $("#MaxWin").window({
                width:1000,
                height:550,
                top:windowHight-570,
                left:windowWidth-1020,
                title:"查询结果",
                collapsible:false,
                minimizable:false,
                maximizable:true,
                iconCls:'icon-w-paper',
                closable:true,
                onClose:function(){maxFlag="N"}
            });
            if( document.getElementById('assChangebtn').className=="icon-textedit")
            {
                $("#MaxWin").panel('setTitle','文本编辑')
             }
            maxFlag="N"
            var view3 = document.getElementById("view3");
            var view4 = document.getElementById("view4");
            if(view4.style.display=="none")
            {   
                //判断是多条件查询还是单条件查询
                var maxview1=document.getElementById("maxview1");
                var maxview2 = document.getElementById("maxview2");
                maxview1.style.display = "block";
                maxview2.style.display="none";
                var flagstr=$('#bookstr').text();
                if((flagstr.indexOf(":")>0)&&flagstr!="")
                {
                    var flag="MaxY"
                    maxWinFoot(flag)
                }
                else
                {
                    var flag="MaxN"
                    maxWinFoot(flag)
                }
            }
            else if(view3.style.display=="none")
            {
                var maxview1=document.getElementById("maxview1");
                var maxview2 = document.getElementById("maxview2");
                maxview1.style.display = "none";
                maxview2.style.display="block";
                //var html=$('#maxTextCopy').text();
                //var url="../scripts/bdp/App/BDPSystem/Ueditor/maxIndex.csp"+"?html="+html;
                //$('#uploadMax').attr("src",url);
                setTimeout(function(){
                		   var html=$('#maxTextCopy').text(); 
	   						var url="../scripts/bdp/App/BDPSystem/Ueditor/mkbmaxindex.csp";
	   						$('#uploadMax').attr("src",url);
	   						//alert(html)
                },100)
            }

        }
    });
    //  放大功能区足迹以及事件生成
    function maxWinFoot(flag)
    {
        //判断小窗口的足迹
        if(flag=="MaxY" && $('#searchId2').text()!="")
        {
            var BaseId=$('#searchId2').text();
        }
        else if(flag=="MaxN" && $('#searchId1').text()!="")
        {
            var BaseId=$('#searchId1').text();
        }
        //若三个足迹都在,只需判断第三个足迹
        if(document.getElementById("footThree"))
        {
            //每次先清掉足迹3
            $('#winfoot3').remove();
            $('#arrowMax2').remove();
            var TermId=$('#diaId').text();
            var ProId=$('#diaId3').text();
            //获取描述
            var BaseDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",BaseId);
            var TermDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",TermId);    
            var ProDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",ProId);
            $('#winimgId').show();
            $('#winfoot1').text(BaseDesc);
            $('#winfoot2').text(TermDesc);
            $('#arrowMax1').show();
            $('#footLarge').append("<td id='arrowMax2'>></td><td id='winfoot3'>"+ProDesc+"</td>");
            //为iframe赋csp
            //判断是哪种类型的属性
            var ProDrType=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetType",ProId);
            //var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+ProDr;
            if(ProDrType=="L")
            {
                //双击数据跳转到内容界面（列表型）
                var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+ProId+"&propertyName="+ProDesc;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);
            }
            else if(ProDrType=="T")
            {
                //列表型
                var url="../csp/dhc.bdp.mkb.mkbassdetailtree.csp"+"?property="+ProId;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);
            }
            else if(ProDrType=="F")
            {
                //文本型
                var url="../csp/dhc.bdp.mkb.mkbassdetailtext.csp"+"?property="+ProId;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);
            }
            else if(ProDrType=="P")
            {
                //引用属性格式属性内容维护模块
                var url="../csp/dhc.bdp.mkb.mkbassdetailproperty.csp"+"?property="+ProId+"&propertyName="+ProDesc;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);
            }
            else if(ProDrType=="S")
            {
                //引用术语格式属性内容维护模块
                var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",ProId)  //引用术语是树形还是列表型
            	if(configListOrTree=="T")
				{
					url="dhc.bdp.mkb.mkbassdetailtreeterm.csp?property="+ProId
				}
				else
				{
					url="dhc.bdp.mkb.mkbassdetaillistterm.csp?property="+ProId
				}
                //var url="../csp/dhc.bdp.mkb.mkbassdetailterm.csp"+"?property="+ProId;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);
            }
            else if(ProDrType == "SS")
            {
                //引用起始节点
                var url="../csp/dhc.bdp.mkb.mkbtermprodetailsingleterm.csp"+"?property="+ProId;
                if ('undefined'!==typeof websys_getMWToken){
                    url += "&MWToken="+websys_getMWToken()
                }
                $('#Maxiframe').attr("src",url);                
            }
            else
            {
             	$('#arrowMax2').remove();
             	$('#winfoot3').remove();
	            //var url= "../csp/dhc.bdp.mkb.mkbassdetailothers.csp"+"?property="+ProId;
	            //$('#Maxiframe').attr("src",url);             
            }
            $('#Maxiframe').attr("src",url);
            oneFootClick(flag,BaseId);
            twoFootClick(TermId);               
        }
        //两个足迹在
        else if(!document.getElementById("footThree") && $('#footTwo').text()!="")
        {
            $('#winimgId').show();
            var TermId=$('#diaId').text();
            var BaseDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",BaseId);
            var TermDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",TermId);
            $('#winfoot1').text(BaseDesc);
            $('#winfoot2').text(TermDesc);
            $('#arrowMax1').show();
            var flagInfo="Y"
            var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+TermId+"&flagP="+flagInfo;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#Maxiframe').attr("src",url);
            oneFootClick(flag,BaseId);
            twoFootClick(TermId);   
        }
        //一个足迹在
        else if(!document.getElementById("footThree") && $('#footTwo').text()=="" &&  $('#footOne').text()!="")
        {
            $('#winfoot2').text('')
            $('#winimgId').show();
            var BaseDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",BaseId);
            $('#winfoot1').text(BaseDesc);
            var searchstr = $('#bookstr').text()
            var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseId+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#Maxiframe').attr("src",url);
            //$('#bookstr').text(searchstr);
            oneFootClick(flag,BaseId);
            var TermId=$('#diaId').text();
            twoFootClick(TermId);
        }
    }
    //第一个点击事件
    function oneFootClick(flag,BaseId)
    {
        var searchstr = $('#bookstr').text()
        //重新生成足迹点击事件
        $('#winfoot1').click(function(e){
            //var flag="MaxY"
            var url="../csp/dhc.bdp.mkb.mkbassterm.csp"+"?base="+BaseId+"&str="+searchstr+"&flag="+flag+"&matchflag="+matchflag;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#Maxiframe').attr("src",url);
            $('#winfoot2').text('');
            $('#winfoot3').remove();
            $('#arrowMax1').hide();
            $('#arrowMax2').remove();
        });
    }
    //第二个点击事件
    function twoFootClick(TermId)
    {
        //点击属性足迹
        $('#winfoot2').click(function(e){
            var flagInfo="Y"
            var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+TermId+"&flagP="+flagInfo;
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#Maxiframe').attr("src",url);
            $('#winfoot3').remove();
            $('#arrowMax2').remove();
        }); 
    }
    /***********************************************放大窗口数据显及足迹 结束*****************/ 
    
    /***********************************************给崔瑞加的功能*****************************/
    $('#searchCRBtn').click(function(){
        var basedesc = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "getTermDesc",base)
        if(basedesc == "解剖学_主要部位")
        {
            var baseType = "part"
        }
        else if(basedesc == "生理病理_主要病因")
        {
            var baseType = "dis"
        }
        else
        {
            var baseType = ""
        }
	    var term=$('#mygrid').datagrid('getSelected');
	    if(term)
	    {
		    var termid=term.MKBTRowId;
		}
	    else
	    {
		    $.messager.alert('错误提示','请先选择一条记录!',"error");
		    return;
		}
        var url="../csp/dhc.bdp.mkb.mkbasstermforcr.csp"+"?termid="+termid+"&baseType="+baseType
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
        $('#myiframe').attr("src",url);	   
	})
}
//泡芙展示方法
init = function(){
    var load_time = 0
	$("#addType").popover({
        content:
            '<div id=popover_layout style="height:480px;width:280px"></div>',
        onShow:function(e,value){
            if(load_time<1)
            {
                loadgrid();
                load_time = 1;	
            }
        },
	    trigger:'hover'
    });
	function loadgrid(flag){
        $('#popover_layout').layout();
        $('#popover_layout').layout('add',{
            region: 'north',      
            collapsible:false,
            split: true,  
            border:false,
            height:38,
            id:'north_layout'
        });
        $('#north_layout').append('<input id="searchIn"  type="text" style="width:278px;" placeholder="请输入查询条件...">')
        $('#popover_layout').layout('add',{
            region: 'center',      
            split: true,  
            border:false,
            id:'center_layout'
        })
        $('#center_layout').append('<table data-options="fit:true"  id="basegrid" ></table>');
        $('#popover_layout').layout('resize');
        $('#searchIn').searchbox({});
        $("#searchIn").searchbox({
            searcher:function(value,name){
                $.cm({
                    ClassName:"web.DHCBL.MKB.MKBAssInterface",
                    MethodName:"GetTermBaseSet",
                    desc:value
                },function(JsonData){
                    $('#basegrid').datagrid('load',{ 
                        'desc':value
                     });
                });
            }
        });
        var BASE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTermBaseSet";
        var basecolumns =[[
            {field:'ID',title:'代码',hidden:true},
            {field:'Desc',title:'知识库',width:278,sortable:true, align:'left'}
        ]];
        $('#basegrid').datagrid({
            autoRowHeight: true,
            columns: basecolumns,  //列信息
            pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
            singleSelect:true,
            remoteSort:false,
            url:BASE_ACTION_URL,
            bodyCls:'panel-header-gray',
            headerCls:'panel-header-gray',
            idField:'ID',
            fitColumns:true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize :0,
            onLoadSuccess: function(data) { 
            },//实时加载
            onDblClickRow:function(index,row)
            {
                $("#addType").popover('hide');
                if(flag==1)
                {
                    closeBaseGridEasy(row);
                    $("#AssSearch").combobox('setValue','')
                    $('#myiframe').attr("src","");
                    $('#imgId').hide();
                    $('#footTwo').text("");
                    $('#footOne').text("");
                    $('#arrow1').hide();
                    if($('#arrow2').attr("id"))
                    {
                        $('#arrow2').remove();
                        $('#footThree').remove(); 
                    }
                }
                if(flag==2)
                {
                    closeBaseGridHard(row);
                    var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+baseAll+"&ResultSetType=array"
                    for (var i = 0; i < row+1; i++)
                    {
                        $('#desc'+i).combobox('clear');
                        $('#desc'+i).combobox('reload',url);
                        $('#descT'+i).val('');//清空文本框
                        
                        var parentobj = $('#descT'+i).parent()
                        parentobj.html('');
                        parentobj.append('<input id="descT'+i+'" type="text" style="width:80px">')
                        $('#descT'+i).validatebox({});    
                    }
                    $('#myiframe').attr("src","");
                    $('#imgId').hide();
                    $('#footTwo').text("");
                    $('#footOne').text("");
                    $('#arrow1').hide();
                    if($('#arrow2').attr("id"))
                    {
                        $('#arrow2').remove();
                        $('#footThree').remove(); 
                    }                    
                }
            }
        });
        $('#basegrid').datagrid('resize')
        $('div.pagination-info').remove();//移除分页工具  
    } 
    function closeBaseGridHard(rowData)
    {
        //双击tooltip显示术语值
        var tt = $HUI.tooltip('#toti',{
            content:rowData.Desc,
            position: 'bottom' //top , right, bottom, left
        });
        $('#searchId2').text(rowData.ID);
        var base=rowData.ID;
        var url=$URL+"?ClassName=web.DHCBL.MKB.MKBAssInterface&QueryName=GetPublicCat&base="+base+"&ResultSetType=array"
        for (var i = 0; i < row+1; i++)
        {
            $('#desc'+i).combobox('clear');//清空下拉框
            $('#descT'+i).val('');//清空文本框
            $('#desc'+i).combobox('reload',url);

            //$('#desc'+i).combobox('enable'); 
            var parentobj = $('#descT'+i).parent()
            parentobj.html('');
            parentobj.append('<input id="descT'+i+'" type="text" style="width:80px">')
            $('#descT'+i).validatebox({});    

        }
        $('#basegrid').datagrid('unselectAll');
        //隐藏泡芙
        $("#addType").popover('hide');

    }
    function closeBaseGridEasy(rowData)
    {
        //双击tooltip显示术语值
        var tt = $HUI.tooltip('#addType',{
            content:rowData.Desc,
            position: 'bottom' //top , right, bottom, left
        });
        $('#searchId1').text(rowData.ID);
        changeSearchbox(rowData.ID);
        $('#basegrid').datagrid('unselectAll');
        //隐藏泡芙
        $("#addType").popover('hide');
      
    }
      
}
$(init);
	






