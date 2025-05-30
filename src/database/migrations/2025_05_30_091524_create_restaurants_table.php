<?php

use App\Enums\OperationalStatus;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // /**
    //  * The database connection that should be used by the migration.
    //  *
    //  * @var string
    //  */
    // protected $connection = 'pgsql';

    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('restaurants', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('address');
            $table->foreignId('cuisine_type_id')
                ->references('id')
                ->on('cuisine_types');
            $table->enum('status', array_column(OperationalStatus::cases(), 'value'))
                ->default(OperationalStatus::OPEN->value)
                ->nullable(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('restaurants', function (Blueprint $table) {
            $table->dropForeign(['cuisine_type_id']);
        });

        Schema::dropIfExists('restaurants');
    }
};
