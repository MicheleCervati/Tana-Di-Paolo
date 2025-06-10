<?php /**
 * @var string $path
 */ ?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container my-3">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">Registrazione Nuovo Utente</h3>
                    </div>
                    <div class="card-body">
                        <form action="<?= $path ?>action/register" method="POST">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="nome" class="form-label">Nome</label>
                                    <input type="text" class="form-control" id="nome" name="nome"
                                           placeholder="Inserisci il tuo nome" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="cognome" class="form-label">Cognome</label>
                                    <input type="text" class="form-control" id="cognome" name="cognome"
                                           placeholder="Inserisci il tuo cognome" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       placeholder="Inserisci la tua email" required>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Password" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="confirm_password" class="form-label">Conferma Password</label>
                                    <input type="password" class="form-control" id="confirm_password"
                                           name="confirm_password" placeholder="Conferma password" required>
                                </div>
                            </div>
                            <small class="form-text text-muted">
                                La password deve contenere almeno 8 caratteri, inclusi numeri, lettere maiuscole,
                                minuscole e caratteri speciali.
                            </small>
                            <div class="d-grid gap-2  mt-2">
                                <?php if (isset($_GET['ref'])) { ?><input type="hidden" name="referer"
                                                                          value="<?= $_GET['ref'] ?>"> <?php } ?>
                                <button type="submit" class="btn btn-primary">Registrati</button>
                                <a href="<?= $path ?>account/login<?php if (isset($_GET['ref'])) {
                                    echo '?ref=' . $_GET['ref'];
                                } ?>" class="btn btn-outline-secondary">Hai già un account? Accedi</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

<?php require 'App/View/component/footer.php'; ?>