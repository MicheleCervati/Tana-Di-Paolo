<?php /**
 * @var string $path
 */ ?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container my-3">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">Login Personale</h3>
                    </div>
                    <div class="card-body">
                        <form action="<?= $path ?>action/login" method="POST">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email address</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       placeholder="Enter email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Password" required>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                                <label class="form-check-label" for="remember">Remember me</label>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>
                            <?php if (isset($_GET['ref'])) { ?><input type="hidden" name="referer"
                                                                      value="<?= $_GET['ref'] ?>"> <?php } ?>
                        </form>
                        <div class="text-center mt-3">
                            <a href="<?= $path ?>account/register<?php if (isset($_GET['ref'])) {
                                echo '?ref=' . $_GET['ref'];
                            } ?>" class="btn btn-outline-secondary d-block">Non hai un account? Registrati</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<?php require 'App/View/component/footer.php'; ?>