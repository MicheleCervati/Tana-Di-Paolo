<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>





<div class="background">
    <h1>Carrello</h1>
<div id="display"></div>

<div id="paga"></div>


</div>

    <script>let path = '<?=$path?>'</script>
    <script src='<?=$path?>Public/function/carrello.js'></script>

<?php require 'App/View/component/footer.php'; ?>