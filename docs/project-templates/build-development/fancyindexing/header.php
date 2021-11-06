<?php
class FancyIndexing {
    /**
     * @return string
     */
    public function getDirectoryTitle() {
        $directory = (!empty($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '');

        $pos = strpos($directory, '?');
        if ($pos !== false) {
            $directory = substr($directory, 0, $pos);
        }

        if($directory == '' OR $directory == '/') {
            $directory = 'Index of /';
        }

        $directory = urldecode($directory);
        return $directory;
    }

    /**
     * @return string
     */
    public function getServerSoftware() {
        $parts = explode('/', $_SERVER['SERVER_SOFTWARE']);
        $part = reset($parts);
        return strtolower($part);
    }

    /**
     * @return bool
     */
    public function isServerSoftwareApache() {
        return ($this->getServerSoftware() === 'apache');
    }

    /**
     * @return bool
     */
    public function isServerSoftwareNginx() {
        return ($this->getServerSoftware() === 'nginx');
    }
}
$fancyIndexing = new FancyIndexing();

parse_str($_SERVER['QUERY_STRING'], $arguments);
$c = (!empty($arguments['C']) ? $arguments['C'] : '');
$o = (!empty($arguments['O']) ? $arguments['O'] : '');
$v = (!empty($arguments['V']) ? $arguments['V'] : '');
$p = (!empty($arguments['P']) ? $arguments['P'] : '');

if (!in_array($c, ['M', 'S', 'D'])) {
    $c = 'N';
}
?>
<!DOCTYPE HTML>
<html lang="de"><head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo $fancyIndexing->getDirectoryTitle(); ?></title>

    <style>
    body {
        margin: 0;
        padding: 0;
        width: 100%;
        font-family: sans-serif, serif;
        color: #000000;
        background: #CCECFF;
        font-size: 16px;
    }

    img {margin: 0; padding: 0; border: 0;}

    table {
        margin: 20px auto;
        padding: 10px;
        background-color: #FFFFFF;
        border: 2px solid #0099CC;
        border-spacing: 0;
        font-size: 16px;
    }
    tr:hover td {
        background-color: #CCECFF;
    }
    tr:hover td:first-child {
        border-radius: 5px 0 0 5px;
    }
    tr:hover td:last-child {
        border-radius: 0 5px 5px 0;
    }

    table tr td {
        padding-left: 10px;
        padding-right: 10px;
        vertical-align: middle;
    }
    table tr td:nth-child(1) {
        padding-left: 1px;
        padding-right: 5px;
    }
    table tr td:nth-child(2) {
        padding-left: 0;
    }
    table tr td:nth-child(5) {
    }

    table tr td a {
        padding-left: 4px;
        border: 1px dashed transparent;
        border-radius: 2px;
    }
    table tr td a:hover {
        border: 1px dashed #0099CC;
    }

    h1 {
        margin-top: 20px;
        text-align: center;
    }
    h1:before{content:"[ ";}
    h1:after{content:" ]";}

    a {
        text-decoration:none;
        line-height:32px;
        color: black;
    }

    table th a {
        padding: 5px;
        border-radius: 5px;
    }

    a:hover {
        color: #000000;
        background-color: #CCECFF;
    }

    table td a {
        display: block;
    }

    hr {
        margin: 8px 0;
        border: 0;
        border-bottom: 1px solid #0099CC;
    }
    tr:last-child th hr {display: none;}
    input {
        padding: 3px 5px;
        border: 1px solid #0099CC;
        border-radius: 4px;
    }
    select {
        padding: 1px 3px;
    }

    <?php if ($fancyIndexing->isServerSoftwareNginx()) { ?>
    body {
        margin-top: 20px;
        text-align: center;
        font-size: 32px;
        font-weight: bold;
    }
    table {
        font-weight: normal;
        text-align: left;
    }
    <?php } ?>
    </style>
</head>

<body>
<?php if ($fancyIndexing->isServerSoftwareApache()) { ?>
    <h1 id="directory_title"><?php echo $fancyIndexing->getDirectoryTitle(); ?></h1>

    <form action="." method="get" style="text-align: center;">
        <input type="hidden" name="F" value="2" />
        <input type="hidden" name="C" value="<?php echo $c; ?>" />

        <select name="O" onchange="this.form.submit();">
            <option value="A" <?php echo ($o === 'A' ? 'selected="selected"' : '' ); ?>> Ascending</option>
            <option value="D" <?php echo ($o === 'D' ? 'selected="selected"' : '' ); ?>> Descending</option>
        </select>
        <select name="V" onchange="this.form.submit();">
            <option value="0" <?php echo ($v === '0' ? 'selected="selected"' : '' ); ?>> Sort normally</option>
            <option value="1" <?php echo ($v === '1' ? 'selected="selected"' : '' ); ?>> Sort version</option>
        </select>

        <input type="text" name="P" value="<?php echo $p; ?>" placeholder="Filter: *search*" />
    </form>
<?php } ?>

<!--<script src="/.fancyindexing/jquery.min.js"></script>-->
<script>
document.addEventListener('DOMContentLoaded', () => {
    let directoryTitle = document.getElementById('directory_title');
    if (directoryTitle) {
        directoryTitle.innerText = document.title;
    }

    let tableRows = document.querySelectorAll('tr');
    tableRows.forEach(tableRow => {
        let link = tableRow.querySelector('td a');
        if (link) {
            if(typeof link.href !== 'undefined') {
                tableRow.addEventListener('click', (event) => {
                    if (event.target !== link) {
                        if (event.ctrlKey) {
                            window.open(link.href, '_blank');
                        } else {
                            document.location.href = link.href;
                        }
                    }
                });
                tableRow.style.cursor = 'pointer';
            }
        }
    });
}, false);
</script>
