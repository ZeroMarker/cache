/*
/Creator:LiangQiang
*/


///�������ҽ���Ƿ�ϸ�
///input:ҽ����Ϣ,mode(0,��������ʾ����,1,����ʾ����)
///return:0,�ϸ�,>0��������x


CheckOrdItmByPha=function(input,mode)
{
    
    alert("input")
		return "" ;
		/*
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

	*/
	
}


/*
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
			        var script=document.createElement("script");  
					script.setAttribute("type", "text/javascript");  
					script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/jquery-1.7.2.min.js");  
					var heads = document.getElementsByTagName("head");
					if(heads.length) 
					{
						 heads[0].appendChild(script); 
					} 
						
					else  {
						document.documentElement.appendChild(script);
					}
					
					var script=document.createElement("script");  
					script.setAttribute("type", "text/javascript");  
					script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/jquery.easyui.min.js");  
					var heads = document.getElementsByTagName("head");
					if(heads.length) 
					{
						 heads[0].appendChild(script); 
					} 
						
					else  {
						document.documentElement.appendChild(script);
					}
					
					var css="../scripts_lib/jquery-easyui-1.3.5/themes/default/easyui.css";
					addCssByLink(css);
					var css="../scripts_lib/jquery-easyui-1.3.5/themes/icon.css";
					addCssByLink(css);
					var css="../scripts/dhcpha/css/dhcpha.css";
					addCssByLink(css);
					
					
					var script=document.createElement("script");  
					script.setAttribute("type", "text/javascript");  
					script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/locale/easyui-lang-zh_CN.js");  
					var heads = document.getElementsByTagName("head");
					if(heads.length) 
					{
						 heads[0].appendChild(script); 
					} 
						
					else  {
						document.documentElement.appendChild(script);
					}
       
		}

        
		$(function(){

        
					var mydiv=document.createElement("div");
					mydiv.setAttribute("id","PhaResultWin");
	
					//mydiv.style.width="450px"; 
					//mydiv.style.height="200px"; 
					mydiv.style.overflow="hidden";
					mydiv.title="��˽��";
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
						   formatter:function(value,row,index){  
								if (row.desc==""){
									var a = [];
									a.push("<a href='#' ><span class='Attach' title='ҩƷ����'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
									return a; 
								}

							} 
					  }, 
					  {field:'itemid',title:'itemid',hidden:true},
					  {field:'item',title:'ҩƷ/��Ŀ',width:130},
					  {field:'desc',title:'��������',width:260},
					  {field:'flag',title:'�ܿ�',hidden:true}

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
					        titile : "�󷽴���",
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
		 
		 

	�x�x	 
		 
		 
}

*/


