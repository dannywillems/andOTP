package org.shadowice.flocke.andotp.Tasks;

import android.content.Context;
import android.net.Uri;
import androidx.annotation.NonNull;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import javax.crypto.SecretKey;
import org.shadowice.flocke.andotp.R;
import org.shadowice.flocke.andotp.Utilities.Constants;
import org.shadowice.flocke.andotp.Utilities.EncryptionHelper;
import org.shadowice.flocke.andotp.Utilities.StorageAccessHelper;

public class EncryptedRestoreTask extends GenericRestoreTask {
    private final String password;
    private final boolean oldFormat;

    public EncryptedRestoreTask(Context context, Uri uri, String password, boolean oldFormat) {
        super(context, uri);
        this.password = password;
        this.oldFormat = oldFormat;
    }

    @Override
    @NonNull
    protected BackupTaskResult doInBackground() {
        boolean success = true;
        String decryptedString = "";

        try {
            byte[] data = StorageAccessHelper.loadFile(applicationContext, uri);

            if (oldFormat) {
                SecretKey key = EncryptionHelper.generateSymmetricKeyFromPassword(password);
                byte[] decrypted = EncryptionHelper.decrypt(key, data);

                decryptedString = new String(decrypted, StandardCharsets.UTF_8);
            } else {
                byte[] iterBytes = Arrays.copyOfRange(data, 0, Constants.INT_LENGTH);
                byte[] salt =
                        Arrays.copyOfRange(
                                data,
                                Constants.INT_LENGTH,
                                Constants.INT_LENGTH + Constants.ENCRYPTION_IV_LENGTH);
                byte[] encrypted =
                        Arrays.copyOfRange(
                                data,
                                Constants.INT_LENGTH + Constants.ENCRYPTION_IV_LENGTH,
                                data.length);

                int iter = ByteBuffer.wrap(iterBytes).getInt();

                SecretKey key = EncryptionHelper.generateSymmetricKeyPBKDF2(password, iter, salt);

                byte[] decrypted = EncryptionHelper.decrypt(key, encrypted);
                decryptedString = new String(decrypted, StandardCharsets.UTF_8);
            }
        } catch (Exception e) {
            success = false;
            e.printStackTrace();
        }

        if (success) {
            return BackupTaskResult.success(BackupTaskResult.ResultType.RESTORE, decryptedString);
        } else {
            return BackupTaskResult.failure(
                    BackupTaskResult.ResultType.RESTORE,
                    R.string.backup_toast_import_decryption_failed);
        }
    }
}
