
CheckOrdItmByPha=function(input,mode)
{
    
    var ret=tkMakeServerCall("web.DHCSTPHCMADDINST", "PassOrdItmByPha",input);
    
    var tmparr=ret.split("^");
	var questitonflag=tmparr[0];
	var cnt=tmparr[1];
	var pid=tmparr[2];
	

	if(questitonflag!=""){	


	          if (mode==1){


		          OpenAdtResultWin(ret);
	          }	    					    
		      
	}
    
	return questitonflag 
}




function addCssByLink(url){  
   var doc=document;  
    var link=doc.createElement("link");  
    link.setAttribute("rel", "stylesheet");  
    link.setAttribute("type", "text/css");  
    link.setAttribute("href", url);  
  
    var heads = doc.getElementsByTagName("head");  
    if(heads.length)  
        heads[0].appendChild(link);  
    else  
        doc.documentElement.appendChild(link); 

     
}

function CloseAdtResultWin()
{
      $(function(){
	      
	      
	       $('#PhaResultWin').window('close');
      })
}

function OpenAdtResultWin(input)
{
        
		if (AdtWinOpen==1){	
        	CloseAdtResultWin();

		}
        
        if (typeof(AdtWinOpen) == "undefined") 
        {			
			ImportEasyUi();
		}


		$(function(){

        
					var mydiv=document.createElement("div");
					mydiv.setAttribute("id","PhaResultWin");
	
					//mydiv.style.width="450px"; 
					//mydiv.style.height="200px"; 
					mydiv.style.overflow="hidden";
					mydiv.title="审核结果";
					mydiv.closable="false";
					mydiv.minimizable="false";
					mydiv.maximizable="false";
					mydiv.collapsible="false";
					document.body.appendChild(mydiv);

					//var a="<div>"+"<a id='btn' href='#' class='easyui-linkbutton' >easyui</a>"
					var a="<div>"
					var a=a+"<table class='easyui-datagrid'  id='AdtResultGrid'></table>"
					var a=a+"</div>"

					
					document.getElementById("PhaResultWin").innerHTML=a ;

					$('#AdtResultGrid').datagrid({

					  //title:'123',
					  loadMsg:'',
					  width:436, 
					  iconCls: 'Attach',
					  height:168,
					  //fit:true,
					  border:false,
					  fitColumns:false,
					  singleSelect:true,
					  idField:'itemid',
					  //treeField:'item', 
					  nowrap: false,
					  striped: true,
					  //showHeader:false,
					  columns:[[ 
					  {field:'opt',title:'',width:20, 
						   //formatter:function(value,row,index){  
								//if (row.desc==""){
								//	var a = [];
								//	a.push("<a href='#' href=\"javascript:void(down('", row.itemid, "'));\"><span class='Attach' title='药品名称'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
								//	return a; 
								//}

							//} 
							formatter: fomartOperation 
					  }, 
					  {field:'itemid',title:'itemid',hidden:true},
					  {field:'item',title:'药品/项目',width:130},
					  {field:'desc',title:'问题描述',width:260},
					  {field:'flag',title:'管控',hidden:true},
                      {field:'drugid',title:'药品ID',hidden:true}
					  ]],
					  
					  rowStyler:function(index,row){    
						if (row.flag==1){    
								return 'background-color:pink;';    
							} 
							
						if (row.desc==""){    
								//return 'color:black;font-weight:bold;';  
								//return 'font-weight:bold;font-size=108px;';  
							}    
						}    

				    });


	
					$('#PhaResultWin').window({
	
					        closable:true,
					        shadow:false,
					        width:450,
					        height:200,
					        titile : "审方窗口",
					        onOpen:function()
					        {
						        
						        AdtWinOpen=1 ;

					        },
					        onClose:function()
					        {
						         AdtWinOpen=0 ;
						         $(this).window("destroy");
						         //$('#AdtResultGrid').datagrid('getPanel').panel('destroy');

					        }
					        

			        });

			    //style.pixelLeft = window.event.clientX + window.document.body.scrollLeft + 6; 
      	        //style.pixelTop = window.event.clientY + window.document.body.scrollTop + 9;     

			    //var divHeight = 450 //parseInt(mywin.offsetHeight, 10);
				//var divWidth = 400  //parseInt(mywin.offsetWidth, 10);
				//var docWidth = document.body.clientWidth;
				//var docHeight = document.body.clientHeight;
				//var divLeft=  docWidth - divWidth + parseInt(document.body.scrollLeft, 10);
				//var divTop= docHeight - divHeight + parseInt(document.body.scrollTop, 10);

                //$('#PhaResultWin').window({left:"600px", top:window.document.body.scrollTop});
               
			  
			  reload(input);

		      function reload(input){
			      
			      		var url="dhcpha.clinical.action.csp";
					    var _json = jQuery.param({ "action":"GetOrdItmAdtResult","input": input });
						var request = $.ajax({
							url: url,
							type: "POST",
							async: false,
							data: _json,
							dataType: "json",
							//contentType: "charset=utf-8",
							cache: false,
							success: function (json, textStatus) {

									$("#AdtResultGrid").datagrid("loadData",json);
							},
							error: function (XMLHttpRequest, textStatus, errorThrown) { 
								    //alert(XMLHttpRequest.readyState); 
								}
						});
						
						
		      }
        

		            

           

		})
		 
		 



		﹛﹛	 
		 
		 
}

//显示药品说明书
function showDrug(drugid)
{
		
	    var url="dhcpha.clinical.action.csp";
		var mydiv=document.createElement("div");
		mydiv.setAttribute("id","showDrugWin"); 
		mydiv.style.overflow="hidden";
		mydiv.style.width="850px"; 
		mydiv.style.height="400px";
		mydiv.title="药品说明书";
		mydiv.closable="true";
		mydiv.minimizable="false";
		mydiv.maximizable="false";
		mydiv.collapsible="false";
		document.body.appendChild(mydiv);

		var tbldiv="<div>"
		var tbldiv=tbldiv+"<table class='easyui-datagrid'  id='DrugInstInfoGrid'></table>"
		var tbldiv=tbldiv+"</div>"
		
		document.getElementById("showDrugWin").innerHTML=tbldiv ;


		$('#showDrugWin').window({

				//closable:true,
				shadow:false//,
				//width:850,
				//height:400
				

		});
        
		$('#DrugInstInfoGrid').datagrid({

				border:false,
				width:835,
				height:350,
				//fit:true,
				//rownumbers:true,
				remoteSort:false,
				nowrap:false,
				fitColumns:true,
				//data:data,
				nowrap:false,
				idField:'itmcode',
				singleSelect:true,
				striped:true,
				showHeader:false,
				url:url,
				queryParams: {
					action:'Query',
					drugid:drugid
					
				},
				columns:[[
					{field:'itmcode',title:'代码',width:10,sortable:true,hidden:true},
					{field:'itmdesc',title:'描述',width:200,align:'left'}
				
				 ]],
				groupField:'itmcode',
				view: groupview,
				groupFormatter:function(value, rows){
					return value ;
				 }    
			 
		 
	    });






}


function fomartOperation(value, rowData, rowIndex) {
		if (rowData.desc==""){
		var a = [];
		a.push("<a style='text-decoration:none;' href=\"javascript:void(showDrug('"+ rowData.drugid +"'));\"><span class='Attach' title='药品名称'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
		return a; 
		}
}