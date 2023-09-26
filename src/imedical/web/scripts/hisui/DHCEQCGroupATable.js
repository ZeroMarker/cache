//安全组访问配件代码	add by wjt 2019-02-19


function BodyLoadHandler() 
{	
    InitUserInfo();
	initButtonWidth(); 
	initButton();	//Mozy003003	1246525		2020-3-27	修正方法名大小写
}


document.body.onload = BodyLoadHandler;