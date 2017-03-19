<%@ Page Language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<WebPartPages:AllowFraming ID="AllowFraming" runat="server" />

<html>
<head>
	<title></title>

	<script type="text/javascript" src="../Scripts/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="../Scripts/jquery.slides.js"></script>
	


	<link href="../Content/example.css" rel="stylesheet" />
	<link href="../Content/font-awesome.min.css" rel="stylesheet" />

	<style>
body {
      -webkit-font-smoothing: antialiased;
      font: normal 15px/1.5 "Helvetica Neue", Helvetica, Arial, sans-serif;
      color: #232525;
     
    }

    #slides {
      display: none
    }

    #slides .slidesjs-navigation {
      margin-top:5px;
    }

		a.slidesjs-next,
		a.slidesjs-previous,
		a.slidesjs-play,
		a.slidesjs-stop {
			background-image: url(../Images/btns-next-prev.png);
			background-repeat: no-repeat;
			display: block;
			width: 12px;
			height: 18px;
			overflow: hidden;
			text-indent: -9999px;
			float: left;
			margin-right: 5px;
		}

    a.slidesjs-next {
      margin-right:10px;
      background-position: -12px 0;
    }

    a:hover.slidesjs-next {
      background-position: -12px -18px;
    }

    a.slidesjs-previous {
      background-position: 0 0;
    }

    a:hover.slidesjs-previous {
      background-position: 0 -18px;
    }

    a.slidesjs-play {
      width:15px;
      background-position: -25px 0;
    }

    a:hover.slidesjs-play {
      background-position: -25px -18px;
    }
	

    a.slidesjs-stop {
      width:18px;
      background-position: -41px 0;
    }

    a:hover.slidesjs-stop {
      background-position: -41px -18px;
    }

    .slidesjs-pagination {
      margin: 7px 0 0;
      float: right;
      list-style: none;
    }

    .slidesjs-pagination li {
      float: left;
      margin: 0 1px;
    }

    .slidesjs-pagination li a {
      display: block;
      width: 13px;
      height: 0;
      padding-top: 13px;
      background-image: url(../Images/pagination.png);
      background-position: 0 0;
      float: left;
      overflow: hidden;
    }

    .slidesjs-pagination li a.active,
    .slidesjs-pagination li a:hover.active {
      background-position: 0 -13px
    }

    .slidesjs-pagination li a:hover {
      background-position: 0 -26px
    }

    #slides a:link,
    #slides a:visited {
      color: #333
    }

    #slides a:hover,
    #slides a:active {
      color: #9e2020
    }

    .navbar {
      overflow: hidden
    }

   

  </style>
 

	<script type="text/javascript">


        var hostweburl;
        var appweburl;

        // Load the required SharePoint libraries
        $(document).ready(function () {
            hostweburl = decodeURIComponent(getQueryStringParameter("SPHostUrl"));
            appweburl = decodeURIComponent(getQueryStringParameter("SPAppWebUrl"));
            var scriptbase = hostweburl + "/_layouts/15/";
            $.getScript(scriptbase + "SP.RequestExecutor.js", execCrossDomainRequest);

        });

        // Function to prepare and issue the request to get SharePoint data
        function execCrossDomainRequest() {
            var executor = new SP.RequestExecutor(appweburl);

            // Deals with the issue the call against the app web.
            executor.executeAsync({
                url: appweburl + "/_api/SP.AppContextSite(@target)/web/lists/getbytitle('spo16Bild')/items?@target='" + hostweburl + "'&$select=EncodedAbsUrl",
                method: "GET",
                headers: { "Accept": "application/json; odata=verbose" },
                success: successHandler,
                error: errorHandler
            }
            );
        }

        // Function to handle the success event. Prints the data to the page.
        function successHandler(data) {
            var jsonObject = JSON.parse(data.body);
            var items = [];
            var results = jsonObject.d.results;

            //items.push("<div id='banner-slide'>");
            //items.push("<div id='slides'>");

            $(results).each(function () {

                var imgURL = this.EncodedAbsUrl;
                var mainurl = imgURL.substring(0, imgURL.lastIndexOf("/") + 1);
                var fileextension = imgURL.substring(imgURL.lastIndexOf(".") + 1, imgURL.length);
                var imgnameVar = imgURL, imgname;
                imgname = imgnameVar.split('/').pop().split('.').shift();
                var thumb = '_w/';
                var extension = '.JPG';


                items.push('' +
                    ' <img src="' + mainurl + thumb + imgname + '_' + fileextension + extension + '"/' + 'title=' + '"' + this.Title + '"' + ' />' +

                    '');


            });
            // end data.d.results	



            $("#slides").html(items.join(''));


            $('#slides').slidesjs({
                width: 200,
                height: 200,
                play: {
                    active: true,
                    auto: true,
                    interval: 4000,
                    swap: true
                }
            });

            // End Start Image Slider

        }


        // Function to handle the error event. Prints the error message to the page.
        function errorHandler(data, errorCode, errorMessage) {
            document.getElementById("slides").innerText = "Could not complete cross-domain call: " + errorMessage;
        }

        // Function to retrieve a query string value.
        function getQueryStringParameter(paramToRetrieve) {
            var params =
                document.URL.split("?")[1].split("&");
            var strParams = "";
            for (var i = 0; i < params.length; i = i + 1) {
                var singleParam = params[i].split("=");
                if (singleParam[0] == paramToRetrieve)
                    return singleParam[1];
            }
        }
	</script>

</head>
<body>


	<div id="slides"> 

	</div>

</body>
</html>
